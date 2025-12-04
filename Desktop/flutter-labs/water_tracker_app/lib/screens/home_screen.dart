import 'package:flutter/material.dart';
import '../widgets/water_progress_bar.dart';
import '../services/water_tracker_service.dart';
import 'add_water_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WaterTrackerService _trackerService = WaterTrackerService();

  // Мотивирующие цитаты
  final List<String> _motivationalQuotes = [
    'Вода - источник жизни! Пейте регулярно.',
    'Хорошее увлажнение улучшает концентрацию.',
    'Стакан воды перед едой помогает пищеварению.',
    'Вода выводит токсины из организма.',
    'Пейте воду для здоровой кожи!',
  ];
  int _currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    // Добавим несколько тестовых записей
    _addTestEntries();
  }

  void _addTestEntries() {
    final now = DateTime.now();
    _trackerService.addWaterEntry(250);
    _trackerService.addWaterEntry(500);
  }

  void _changeQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _motivationalQuotes.length;
    });
  }

  void _handleQuickAdd(int amount) {
    setState(() {
      _trackerService.addWaterEntry(amount);
    });

    // Показать уведомление
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавлено $amount мл воды!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    trackerService: _trackerService,
                    onGoalChanged: () => setState(() {}),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Прогресс-бар
            WaterProgressBar(
              progress: _trackerService.progress,
              currentAmount: '${_trackerService.totalDrunkToday}',
              targetAmount: '${_trackerService.dailyGoal}',
            ),

            const SizedBox(height: 30),

            // Быстрые кнопки
            const Text(
              'Быстрое добавление:',
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

            // Кнопка добавления своей порции
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddWaterScreen(),
                  ),
                );

                if (result != null && result is int) {
                  setState(() {
                    _trackerService.addWaterEntry(result);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Добавить свою порцию',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка истории
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      entries: _trackerService.entries,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Colors.blue),
              ),
              icon: const Icon(Icons.history, color: Colors.blue),
              label: const Text(
                'История потребления',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 30),

            // Мотивирующая цитата
            GestureDetector(
              onTap: _changeQuote,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 10),
                        const Text(
                          'Совет дня:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          onPressed: _changeQuote,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _motivationalQuotes[_currentQuoteIndex],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
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

  Widget _buildQuickButton(int amount) {
    return GestureDetector(
      onTap: () => _handleQuickAdd(amount),
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
            '$amount мл',
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