import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DessertShopApp());
}

class DessertShopApp extends StatelessWidget {
  const DessertShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dessert Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ── Colour ─────────────────────────────────────────────
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC73B0F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // ── Typography ─────────────────────────────────────────
        textTheme: GoogleFonts.redHatTextTextTheme().copyWith(
          // Product name, cart heading
          titleMedium: GoogleFonts.redHatText(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          // Category label, small muted text
          bodySmall: GoogleFonts.redHatText(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          // Standard body text
          bodyMedium: GoogleFonts.redHatText(
            fontSize: 14,
            color: Colors.black87,
          ),
          // Price text
          labelLarge: GoogleFonts.redHatText(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        // ── Card defaults ──────────────────────────────────────
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),

        // ── ElevatedButton defaults ────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // Reads from colorScheme automatically in M3
            backgroundColor: const Color(0xFFC73B0F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
