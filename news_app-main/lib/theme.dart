import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
  ),
);