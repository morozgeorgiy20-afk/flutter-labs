import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
// import 'screens/add_water_screen.dart';
// import 'screens/history_screen.dart';
// import 'screens/settings_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      // Для тестирования других экранов, раскомментируйте:
      // home: const AddWaterScreen(),
      // home: const HistoryScreen(),
    );
  }
}