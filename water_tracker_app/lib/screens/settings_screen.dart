import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;
  final VoidCallback onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.storageService,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final goal = await widget.storageService.getDailyGoal();
    final name = await widget.storageService.getUserName();
    final city = await widget.storageService.getSelectedCity();

    setState(() {
      _goalController.text = goal.toString();
      _nameController.text = name;
      _cityController.text = city;
    });
  }

  @override
  void dispose() {
    _goalController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final goal = int.parse(_goalController.text);
      widget.storageService.setDailyGoal(goal);
      widget.onSettingsChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily goal updated!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveName() {
    widget.storageService.setUserName(_nameController.text);
    widget.onSettingsChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Name updated!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveCity() {
    if (_cityController.text.isNotEmpty) {
      widget.storageService.setSelectedCity(_cityController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('City updated! Weather will refresh soon.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all water history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.storageService.clearWaterEntries();
              widget.onSettingsChanged();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('History cleared!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text('This will delete all your settings and history. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await widget.storageService.clearAllData();
              widget.onSettingsChanged();
              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data reset!'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Reset All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Profile
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveName,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Daily Goal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Goal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(  // <-- ИЗМЕНЕНИЕ: TextField → TextFormField
                        controller: _goalController,
                        decoration: InputDecoration(
                          labelText: 'Amount in ml',
                          border: const OutlineInputBorder(),
                          suffixText: 'ml',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: _saveGoal,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null || intValue <= 0) {
                            return 'Please enter a positive number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Weather
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weather',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City for weather',
                        hintText: 'Example: Moscow, London, Tokyo',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveCity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Weather updates automatically every 3 hours',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Data Management
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _clearHistory,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                        ),
                        child: const Text(
                          'Clear Water History',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _clearAllData,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text(
                          'Reset All Data',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // About
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Water Tracker v1.0',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Stay hydrated and healthy!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Features:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('• Track daily water intake'),
                    const Text('• Weather-based recommendations'),
                    const Text('• Daily motivational quotes'),
                    const Text('• Local data storage'),
                    const Text('• Weather API integration'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Back button
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}