import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DessertShopApp());
}

class DessertShopApp extends StatelessWidget {
  const DessertShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dessert Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC73E1D),
          brightness: Brightness.light,
          surface: const Color(0xFFFCF9F7),
        ),
        scaffoldBackgroundColor: const Color(0xFFFCF9F7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
