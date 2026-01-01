import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Shared Colors ---
  static const Color primaryColor = Color(0xFF5D4037); // Deep Brown
  static const Color secondaryColor = Color(0xFFBF8970); // Terracotta
  static const Color accentColor = Color(0xFFD4AF37); // Gold

  // --- Light Theme ---
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCardColor = Color(0xFFFFFFFF);

  // --- Dark Theme ---
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFE0E0E0);

  // --- Text Styles ---
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: GoogleFonts.lato(fontSize: 16, color: textColor.withOpacity(0.87)),
      bodyMedium: GoogleFonts.lato(fontSize: 14, color: textColor.withOpacity(0.6)),
      titleMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
      headlineSmall: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
    );
  }

  // --- THEME DEFINITIONS ---
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: lightBackground,
        surface: lightCardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: lightCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      textTheme: _buildTextTheme(base.textTheme, Colors.black),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: secondaryColor, // Lighter brown for dark bg
        secondary: secondaryColor,
        tertiary: accentColor,
        background: darkBackground,
        surface: darkCardColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onBackground: darkTextColor,
        onSurface: darkTextColor,
      ),
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor),
        iconTheme: const IconThemeData(color: secondaryColor),
      ),
      textTheme: _buildTextTheme(base.textTheme, darkTextColor),
    );
  }
}
