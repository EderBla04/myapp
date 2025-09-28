import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _primarySeedColor = Colors.deepPurple;

// --- Light Theme ---
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeedColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
    titleTextStyle: GoogleFonts.oswald(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 4,
    shadowColor: Colors.black.withAlpha(25), // ~10% opacity
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.grey.shade50.withAlpha(128), // ~50% opacity
  ),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
  ),
);

// --- Dark Theme ---
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeedColor,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.latoTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.oswald(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 6,
    shadowColor: Colors.black.withAlpha(77), // ~30% opacity
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
  ),
);
