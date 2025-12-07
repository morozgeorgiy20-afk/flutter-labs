class Weather {
  final double temperature;
  final String condition;
  final String location;
  final int humidity;

  Weather({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return Weather(
      temperature: (main['temp'] as num).toDouble(),
      condition: weather['main'],
      location: json['name'],
      humidity: main['humidity'],
    );
  }

  factory Weather.empty() {
    return Weather(
      temperature: 20.0,
      condition: 'Clear',
      location: 'Your City',
      humidity: 50,
    );
  }

  String get waterRecommendation {
    if (temperature > 25) {
      return 'Hot weather! Drink 500ml more water today.';
    } else if (temperature < 10) {
      return 'Cold outside. Don\'t forget warm water.';
    } else if (humidity < 30) {
      return 'Low humidity. Increase water intake.';
    } else {
      return 'Perfect weather for maintaining hydration.';
    }
  }
}