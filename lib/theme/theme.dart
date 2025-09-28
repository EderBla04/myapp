import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores pasteles para PorciApp
const Color _primarySeedColor = Color(0xFF8BC34A); // Verde pastel
const Color _secondaryColor = Color(0xFFFFB74D); // Naranja pastel
const Color _accentColor = Color(0xFFFF8A65); // Rosa coral
const Color _surfaceColor = Color(0xFFF8F5F0); // Beige claro
const Color _backgroundLight = Color(0xFFFFF8E1); // Amarillo muy claro

// Colores específicos para la app
class PorciColors {
  static const Color sowPink = Color(0xFFF8BBD9);
  static const Color pigPink = Color(0xFFFFCCE5);
  static const Color barnBrown = Color(0xFFD7CCC8);
  static const Color grassGreen = Color(0xFFC8E6C9);
  static const Color skyBlue = Color(0xFFBBDEFB);
  static const Color sunYellow = Color(0xFFFFF9C4);
  static const Color moonBlue = Color(0xFF9FA8DA);
}

// --- Light Theme ---
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeedColor,
    brightness: Brightness.light,
    surface: const Color(0xFFFFF8E1), // Fondo amarillo muy claro
    surfaceContainer: const Color(0xFFF8F5F0), // Beige claro para contenedores
    secondary: const Color(0xFFFFB74D), // Naranja pastel
    tertiary: const Color(0xFFFF8A65), // Rosa coral
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF8E1),
  textTheme: GoogleFonts.comicNeueTextTheme().copyWith(
    headlineLarge: GoogleFonts.comicNeue(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF4A4A4A),
    ),
    headlineMedium: GoogleFonts.comicNeue(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF4A4A4A),
    ),
    bodyLarge: GoogleFonts.comicNeue(
      fontSize: 16,
      color: const Color(0xFF4A4A4A),
    ),
    bodyMedium: GoogleFonts.comicNeue(
      fontSize: 14,
      color: const Color(0xFF4A4A4A),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.comicNeue(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: _primarySeedColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: GoogleFonts.comicNeue(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      elevation: 3,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: _primarySeedColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _primarySeedColor, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: GoogleFonts.comicNeue(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      elevation: 2,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 6,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: _primarySeedColor.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: _primarySeedColor.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: _primarySeedColor, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    labelStyle: GoogleFonts.comicNeue(
      color: _primarySeedColor,
      fontWeight: FontWeight.w600,
    ),
  ),
  tabBarTheme: TabBarThemeData(
    labelStyle: GoogleFonts.comicNeue(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    unselectedLabelStyle: GoogleFonts.comicNeue(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.white.withOpacity(0.3),
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white.withOpacity(0.7),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFFFFB74D), // Naranja pastel
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
