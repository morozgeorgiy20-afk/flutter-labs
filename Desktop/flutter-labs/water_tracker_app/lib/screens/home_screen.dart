import 'package:flutter/material.dart';
import '../widgets/water_progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // Навигация будет в ЛР5
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
            const WaterProgressBar(
              progress: 0.65,
              currentAmount: '1300',
              targetAmount: '2000',
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
                _buildQuickButton(context, '250 мл', Icons.local_drink),
                _buildQuickButton(context, '500 мл', Icons.water_drop),
                _buildQuickButton(context, '750 мл', Icons.water),
              ],
            ),

            const SizedBox(height: 20),

            // Кнопка добавления своей порции
            ElevatedButton.icon(
              onPressed: () {
                // Навигация будет в ЛР5
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
                // Навигация будет в ЛР5
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
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 10),
                      Text(
                        'Совет дня:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Регулярное употребление воды улучшает '
                    'метаболизм и способствует сохранению здоровья.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(BuildContext context, String amount, IconData icon) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 5),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}