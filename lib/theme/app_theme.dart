import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primaryColor: const Color(0xFF3366FF),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      iconTheme: const IconThemeData(
        color: Color(0xFF495057),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212529),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF212529),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF495057),
        ),
      ),
    );
  }
}
