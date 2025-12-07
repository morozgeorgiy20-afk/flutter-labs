import '../models/water_entry.dart';

class WaterTrackerService {
  List<WaterEntry> _entries = [];
  int _dailyGoal = 2000; // мл

  List<WaterEntry> get entries => List.from(_entries);
  int get dailyGoal => _dailyGoal;

  int get totalDrunkToday {
    final today = DateTime.now();
    return _entries
        .where((entry) =>
            entry.time.day == today.day &&
            entry.time.month == today.month &&
            entry.time.year == today.year)
        .fold(0, (sum, entry) => sum + entry.amount);
  }

  double get progress => totalDrunkToday / _dailyGoal;

  void addWaterEntry(int amount, {String note = ''}) {
    _entries.insert(0, WaterEntry(
      amount: amount,
      time: DateTime.now(),
      note: note,
    ));
  }

  void setDailyGoal(int goal) {
    if (goal > 0) {
      _dailyGoal = goal;
    }
  }

  void clearEntries() {
    _entries.clear();
  }
}