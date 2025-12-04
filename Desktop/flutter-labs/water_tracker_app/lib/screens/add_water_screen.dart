import 'package:flutter/material.dart';

class AddWaterScreen extends StatelessWidget {
  const AddWaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить воду'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Иллюстрация
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.water_drop,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Заголовок
            const Text(
              'Сколько воды вы выпили?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Поле ввода
            TextField(
              decoration: InputDecoration(
                labelText: 'Объем в миллилитрах',
                prefixIcon: const Icon(Icons.measurement),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Например: 250',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Предустановленные значения
            const Text(
              'Или выберите из списка:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildPresetButton('150 мл'),
                _buildPresetButton('250 мл'),
                _buildPresetButton('330 мл'),
                _buildPresetButton('500 мл'),
                _buildPresetButton('750 мл'),
                _buildPresetButton('1000 мл'),
              ],
            ),

            const SizedBox(height: 30),

            // Кнопка добавления
            ElevatedButton(
              onPressed: () {
                // Логика будет в ЛР5
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'ДОБАВИТЬ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Кнопка отмены
            TextButton(
              onPressed: () {
                // Навигация будет в ЛР5
              },
              child: const Text(
                'ОТМЕНА',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String amount) {
    return OutlinedButton(
      onPressed: () {
        // Логика будет в ЛР5
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue),
      ),
      child: Text(amount),
    );
  }
}