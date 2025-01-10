import 'package:flutter/material.dart';
import 'package:ctrl/screens/home.dart';

void main() => runApp(const CtrlApp());

ThemeData themeData = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  ),
);

class CtrlApp extends StatelessWidget {
  const CtrlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: const HomePage(),
    );
  }
}
