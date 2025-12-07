import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _dailyGoalKey = 'daily_goal';
  static const String _waterEntriesKey = 'water_entries';
  static const String _userNameKey = 'user_name';
  static const String _selectedCityKey = 'selected_city';
  static const String _lastQuoteUpdateKey = 'last_quote_update';
  static const String _lastWeatherUpdateKey = 'last_weather_update';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Daily goal
  Future<int> getDailyGoal() async {
    final prefs = await _prefs;
    return prefs.getInt(_dailyGoalKey) ?? 2000;
  }

  Future<void> setDailyGoal(int goal) async {
    final prefs = await _prefs;
    await prefs.setInt(_dailyGoalKey, goal);
  }

  // Water entries
  Future<List<Map<String, dynamic>>> getWaterEntries() async {
    final prefs = await _prefs;
    final entriesJson = prefs.getString(_waterEntriesKey);

    if (entriesJson != null) {
      final List<dynamic> entries = json.decode(entriesJson);
      return entries.cast<Map<String, dynamic>>();
    }

    return [];
  }

  Future<void> saveWaterEntry(int amount, {String note = ''}) async {
    final entries = await getWaterEntries();
    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'amount': amount,
      'time': DateTime.now().toIso8601String(),
      'note': note,
    };

    entries.insert(0, newEntry);

    final prefs = await _prefs;
    await prefs.setString(_waterEntriesKey, json.encode(entries));
  }

  Future<void> clearWaterEntries() async {
    final prefs = await _prefs;
    await prefs.remove(_waterEntriesKey);
  }

  // User name
  Future<String> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString(_userNameKey) ?? '';
  }

  Future<void> setUserName(String name) async {
    final prefs = await _prefs;
    await prefs.setString(_userNameKey, name);
  }

  // City for weather
  Future<String> getSelectedCity() async {
    final prefs = await _prefs;
    return prefs.getString(_selectedCityKey) ?? 'Moscow';
  }

  Future<void> setSelectedCity(String city) async {
    final prefs = await _prefs;
    await prefs.setString(_selectedCityKey, city);
  }

  // Last quote update time
  Future<DateTime?> getLastQuoteUpdate() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_lastQuoteUpdateKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> updateLastQuoteUpdate() async {
    final prefs = await _prefs;
    await prefs.setInt(_lastQuoteUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Last weather update time
  Future<DateTime?> getLastWeatherUpdate() async {
    final prefs = await _prefs;
    final timestamp = prefs.getInt(_lastWeatherUpdateKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> updateLastWeatherUpdate() async {
    final prefs = await _prefs;
    await prefs.setInt(_lastWeatherUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  // Get today's water total
  Future<int> getTodayWaterTotal() async {
    final entries = await getWaterEntries();
    final today = DateTime.now();
    int total = 0;

    for (var entry in entries) {
      final time = DateTime.parse(entry['time']);
      if (time.year == today.year &&
          time.month == today.month &&
          time.day == today.day) {
        total += entry['amount'] as int;
      }
    }

    return total;
  }
}