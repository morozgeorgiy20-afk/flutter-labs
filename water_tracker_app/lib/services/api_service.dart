import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';
import '../models/weather.dart';

class ApiService {
  static const String _zenQuotesUrl = 'https://zenquotes.io/api/today';

  // Get daily quote about water/health
  Future<Quote> fetchWaterQuote() async {
    try {
      final response = await http.get(Uri.parse(_zenQuotesUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        }
      }
    } catch (e) {
      print('Error fetching quote: $e');
    }

    return Quote.empty();
  }

  // Get weather - исправленная версия
  Future<Weather> fetchWeather({String city = 'Moscow'}) async {
    const apiKey = '119d562eaeffa86d23034412f2399488';

    try {
      // Используем текущий API (не OneCall)
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('Weather API error: ${response.statusCode} - ${response.body}');
        return Weather(
          temperature: 20.0,
          condition: 'Clear',
          location: city,
          humidity: 50,
        );
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return Weather.empty();
    }
  }

  // Альтернативная версия с OneCall 3.0 API (если хотите использовать его)
  Future<Weather> fetchWeatherOneCall({double lat = 55.75, double lon = 37.61}) async {
    const apiKey = '119d562eaeffa86d23034412f2399488';

    try {
      // OneCall 3.0 требует аутентификации через Bearer token в заголовках
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,daily&units=metric&appid=$apiKey'),
        headers: {
          'Authorization': 'Bearer $apiKey', // OneCall 3.0 требует Bearer token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // OneCall 3.0 имеет другую структуру данных
        return Weather(
          temperature: data['current']['temp'],
          condition: data['current']['weather'][0]['main'],
          location: 'Moscow', // OneCall не возвращает название города
          humidity: data['current']['humidity'],
        );
      } else {
        print('OneCall API error: ${response.statusCode}');
        return Weather.empty();
      }
    } catch (e) {
      print('Error fetching OneCall weather: $e');
      return Weather.empty();
    }
  }

  // Get water tips
  Future<List<String>> fetchWaterTips() async {
    // Static tips that could come from API
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      'Drink a glass of water after waking up',
      'Have water before each meal',
      'Carry a water bottle with you',
      'Set water drinking reminders',
      'Eat water-rich foods (cucumbers, watermelon)',
      'Drink more during physical activity',
      'Monitor urine color - it should be light',
      'Don\'t wait until you\'re thirsty',
      'Drink water when you feel tired',
      'Flavor water with lemon or mint if needed',
    ];
  }

  // Get hydration facts
  Future<List<String>> fetchHydrationFacts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      'The human body is about 60% water',
      'Water helps regulate body temperature',
      'Proper hydration improves cognitive function',
      'Water aids digestion and nutrient absorption',
      'Dehydration can cause headaches and fatigue',
      'Water helps keep skin healthy',
      'Men need about 3.7 liters, women 2.7 liters daily',
    ];
  }
}