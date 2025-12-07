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
    try {
      // Стандартный API (weather)
      if (json.containsKey('weather') && json.containsKey('main')) {
        final weather = json['weather'][0];
        final main = json['main'];

        return Weather(
          temperature: (main['temp'] as num).toDouble(),
          condition: weather['main'],
          location: json['name'],
          humidity: main['humidity'],
        );
      }
      // OneCall 3.0 API
      else if (json.containsKey('current')) {
        final current = json['current'];
        final weather = current['weather'][0];

        return Weather(
          temperature: (current['temp'] as num).toDouble(),
          condition: weather['main'],
          location: 'Current Location', // OneCall не имеет названия города
          humidity: current['humidity'],
        );
      }
    } catch (e) {
      print('Error parsing weather JSON: $e');
    }

    return Weather.empty();
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