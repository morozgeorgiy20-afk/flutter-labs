import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                _buildStatItem('Сегодня', '1.3 л'),
                _buildStatItem('Всего', '8.7 л'),
                _buildStatItem('Рекорд', '2.5 л'),
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
                  'Сегодняшние записи:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue[100],
                  label: const Text('5 записей'),
                ),
              ],
            ),
          ),

          // Список записей
          Expanded(
            child: ListView(
              children: const [
                HistoryItem(
                  amount: '250 мл',
                  time: '08:30',
                  icon: Icons.coffee,
                ),
                HistoryItem(
                  amount: '500 мл',
                  time: '10:15',
                  icon: Icons.fitness_center,
                ),
                HistoryItem(
                  amount: '300 мл',
                  time: '12:45',
                  icon: Icons.lunch_dining,
                ),
                HistoryItem(
                  amount: '150 мл',
                  time: '15:20',
                  icon: Icons.local_cafe,
                ),
                HistoryItem(
                  amount: '100 мл',
                  time: '18:00',
                  icon: Icons.water_drop,
                ),
              ],
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
}

class HistoryItem extends StatelessWidget {
  final String amount;
  final String time;
  final IconData icon;

  const HistoryItem({
    super.key,
    required this.amount,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          amount,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Добавлено в $time',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}