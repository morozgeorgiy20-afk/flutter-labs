import 'package:flutter/material.dart';

class WaterProgressBar extends StatelessWidget {
  final double progress; // от 0.0 до 1.0
  final String currentAmount;
  final String targetAmount;

  const WaterProgressBar({
    super.key,
    required this.progress,
    required this.currentAmount,
    required this.targetAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Заголовок
          Text(
            'ВОДНЫЙ БАЛАНС',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),

          // Прогресс-бар
          Stack(
            alignment: Alignment.center,
            children: [
              // Фоновый круг
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),

              // Прогресс
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 15,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(progress),
                  ),
                ),
              ),

              // Процент в центре
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$currentAmount / $targetAmount мл',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Текст под прогресс-баром
          const SizedBox(height: 20),
          Text(
            _getMotivationalText(progress),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }

  String _getMotivationalText(double progress) {
    if (progress < 0.3) return 'Пора начинать пить воду!';
    if (progress < 0.7) return 'Так держать! Продолжайте в том же духе.';
    if (progress < 1.0) return 'Почти достигли цели!';
    return 'Отлично! Вы выполнили дневную норму! 🎉';
  }
}