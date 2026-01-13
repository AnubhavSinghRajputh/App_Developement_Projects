import 'package:flutter/material.dart';
import 'package:project_third/calculator_app/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 60,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
