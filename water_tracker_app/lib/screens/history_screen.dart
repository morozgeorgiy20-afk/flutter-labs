import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const HistoryScreen({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final todayEntries = _filterTodayEntries(entries);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinking History'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Today's statistics
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Today', '${_calculateTodayTotal(entries)} ml'),
                _buildStatItem('Total', '${_calculateTotal(entries)} ml'),
                _buildStatItem('Entries', '${entries.length}'),
              ],
            ),
          ),

          // List header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Entries:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue[100],
                  label: Text('${todayEntries.length} entries'),
                ),
              ],
            ),
          ),

          // Entries list
          Expanded(
            child: todayEntries.isEmpty
                ? const Center(
                    child: Text(
                      'No water entries for today',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todayEntries.length,
                    itemBuilder: (context, index) {
                      final entry = todayEntries[index];
                      return _buildHistoryItem(entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> entry) {
    final time = DateTime.parse(entry['time']);
    final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final note = entry['note'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.water_drop, color: Colors.blue),
        ),
        title: Text(
          '${entry['amount']} ml',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: note.isNotEmpty
            ? Text(note)
            : const Text('No note'),
        trailing: Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filterTodayEntries(List<Map<String, dynamic>> entries) {
    final today = DateTime.now();
    return entries.where((entry) {
      final time = DateTime.parse(entry['time']);
      return time.year == today.year &&
             time.month == today.month &&
             time.day == today.day;
    }).toList();
  }

  int _calculateTodayTotal(List<Map<String, dynamic>> entries) {
    return _filterTodayEntries(entries)
        .fold(0, (sum, entry) => sum + (entry['amount'] as int));
  }

  int _calculateTotal(List<Map<String, dynamic>> entries) {
    return entries.fold(0, (sum, entry) => sum + (entry['amount'] as int));
  }
}