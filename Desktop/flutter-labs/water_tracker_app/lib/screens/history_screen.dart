import 'package:flutter/material.dart';
import '../models/water_entry.dart';

class HistoryScreen extends StatelessWidget {
  final List<WaterEntry> entries;

  const HistoryScreen({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Статистика за день
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Сегодня', '${_calculateTodayTotal(entries)} мл'),
                _buildStatItem('Всего', '${_calculateTotal(entries)} мл'),
                _buildStatItem('Записей', '${entries.length}'),
              ],
            ),
          ),

          // Заголовок списка
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Записи о потреблении:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue[100],
                  label: Text('${entries.length} записей'),
                ),
              ],
            ),
          ),

          // Список записей
          Expanded(
            child: entries.isEmpty
                ? const Center(
                    child: Text(
                      'Нет записей о потреблении воды',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
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

  Widget _buildHistoryItem(WaterEntry entry) {
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
          '${entry.amount} мл',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          entry.note.isNotEmpty ? entry.note : 'Без заметки',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              entry.formattedTime,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              entry.formattedDate,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTodayTotal(List<WaterEntry> entries) {
    final today = DateTime.now();
    return entries
        .where((entry) =>
            entry.time.day == today.day &&
            entry.time.month == today.month &&
            entry.time.year == today.year)
        .fold(0, (sum, entry) => sum + entry.amount);
  }

  int _calculateTotal(List<WaterEntry> entries) {
    return entries.fold(0, (sum, entry) => sum + entry.amount);
  }
}