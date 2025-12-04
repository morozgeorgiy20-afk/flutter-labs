import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/quote.dart';
import '../models/weather.dart';
import '../widgets/water_progress_bar.dart';
import 'add_water_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  late Quote _dailyQuote;
  late Weather _weather;
  List<String> _waterTips = [];
  bool _isLoading = true;
  int _totalWaterToday = 0;
  int _dailyGoal = 2000;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadStorageData(),
        _loadQuote(),
        _loadWeather(),
        _loadWaterTips(),
      ]);
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadStorageData() async {
    final goal = await _storageService.getDailyGoal();
    final name = await _storageService.getUserName();
    final total = await _storageService.getTodayWaterTotal();

    setState(() {
      _dailyGoal = goal;
      _userName = name;
      _totalWaterToday = total;
    });
  }

  Future<void> _loadQuote() async {
    final lastUpdate = await _storageService.getLastQuoteUpdate();
    final now = DateTime.now();

    if (lastUpdate == null || now.difference(lastUpdate).inHours > 24) {
      final quote = await _apiService.fetchWaterQuote();
      await _storageService.updateLastQuoteUpdate();

      setState(() {
        _dailyQuote = quote;
      });
    } else {
      setState(() {
        _dailyQuote = Quote.empty();
      });
    }
  }

  Future<void> _loadWeather() async {
    final city = await _storageService.getSelectedCity();
    final lastUpdate = await _storageService.getLastWeatherUpdate();
    final now = DateTime.now();

    if (lastUpdate == null || now.difference(lastUpdate).inHours > 3) {
      final weather = await _apiService.fetchWeather(city: city);
      await _storageService.updateLastWeatherUpdate();

      setState(() {
        _weather = weather;
      });
    } else {
      setState(() {
        _weather = Weather(
          temperature: 20.0,
          condition: 'Clear',
          location: city,
          humidity: 50,
        );
      });
    }
  }

  Future<void> _loadWaterTips() async {
    final tips = await _apiService.fetchWaterTips();
    setState(() {
      _waterTips = tips;
    });
  }

  Future<void> _addWater(int amount) async {
    await _storageService.saveWaterEntry(amount);
    await _loadStorageData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $amount ml of water!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void _navigateToAddWater() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWaterScreen()),
    );

    if (result != null && result is int) {
      await _addWater(result);
    }
  }

  void _navigateToHistory() async {
    final entries = await _storageService.getWaterEntries();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(entries: entries),
      ),
    );
  }

  void _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          storageService: _storageService,
          onSettingsChanged: _loadStorageData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Greeting
            if (_userName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Hello, $_userName!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

            // Weather widget
            _buildWeatherWidget(),

            const SizedBox(height: 20),

            // Progress bar
            WaterProgressBar(
              progress: _dailyGoal > 0 ? _totalWaterToday / _dailyGoal : 0,
              currentAmount: '$_totalWaterToday',
              targetAmount: '$_dailyGoal',
            ),

            const SizedBox(height: 20),

            // Weather recommendation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.water_drop, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Hydration Tip:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_weather.waterRecommendation),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Daily quote
            _buildQuoteWidget(),

            const SizedBox(height: 20),

            // Quick add buttons
            const Text(
              'Quick Add:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickButton(250),
                _buildQuickButton(500),
                _buildQuickButton(750),
              ],
            ),

            const SizedBox(height: 20),

            // Action buttons
            ElevatedButton.icon(
              onPressed: _navigateToAddWater,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Custom Amount',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: _navigateToHistory,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Colors.blue),
              ),
              icon: const Icon(Icons.history, color: Colors.blue),
              label: const Text(
                'Drinking History',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 20),

            // Water tip of the day
            if (_waterTips.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Tip of the Day:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _waterTips[DateTime.now().day % _waterTips.length],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.cloud, color: Colors.blue, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weather.location,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_weather.temperature.toStringAsFixed(1)}°C, ${_weather.condition}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Humidity: ${_weather.humidity}%',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteWidget() {
    return Card(
      color: Colors.lightBlue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.format_quote, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Quote of the Day:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _dailyQuote.text,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${_dailyQuote.author}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(int amount) {
    return GestureDetector(
      onTap: () => _addWater(amount),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$amount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$amount ml',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}