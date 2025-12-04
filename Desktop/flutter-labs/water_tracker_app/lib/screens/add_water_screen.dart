import 'package:flutter/material.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  final TextEditingController _amountController = TextEditingController();
  int? _selectedAmount;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handlePresetTap(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  void _handleAdd() {
    final amount = int.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      _showErrorDialog('Пожалуйста, введите корректное количество воды');
      return;
    }

    Navigator.pop(context, amount);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Объем в миллилитрах',
                prefixIcon: const Icon(Icons.linear_scale),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Например: 250',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (int.tryParse(value) != _selectedAmount) {
                    _selectedAmount = null;
                  }
                });
              },
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
                _buildPresetButton(150),
                _buildPresetButton(250),
                _buildPresetButton(330),
                _buildPresetButton(500),
                _buildPresetButton(750),
                _buildPresetButton(1000),
              ],
            ),

            const SizedBox(height: 30),

            // Кнопка добавления
            ElevatedButton(
              onPressed: _handleAdd,
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
              onPressed: () => Navigator.pop(context),
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

  Widget _buildPresetButton(int amount) {
    final isSelected = _selectedAmount == amount;

    return ElevatedButton(
      onPressed: () => _handlePresetTap(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[700] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: Text('$amount мл'),
    );
  }
}