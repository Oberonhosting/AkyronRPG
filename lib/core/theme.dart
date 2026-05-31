import 'package:flutter/material.dart';

/// Tema visual do Akyron — paleta vibrante magia sobre fundo sombrio.
class AkyronTheme {
  AkyronTheme._();

  // Paleta principal.
  static const Color obsidian = Color(0xFF0B0A14);
  static const Color deepNight = Color(0xFF141228);
  static const Color violetArcane = Color(0xFF7A2EE0);
  static const Color crimsonAura = Color(0xFFE0285A);
  static const Color goldEon = Color(0xFFE8C547);
  static const Color cyanSpirit = Color(0xFF4FF0E8);
  static const Color paperBeige = Color(0xFFE9DDB6);

  // Auras por sistema de poder.
  static const Map<String, Color> systemAura = {
    'grimoire': Color(0xFF7A2EE0),
    'zanpakuto': Color(0xFF4FF0E8),
    'chakra': Color(0xFF3FB8F0),
    'breathing': Color(0xFFE8C547),
    'nen': Color(0xFF63E07A),
    'cursed': Color(0xFFB02FE0),
  };

  static ThemeData buildDark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: obsidian,
      colorScheme: const ColorScheme.dark(
        primary: violetArcane,
        secondary: goldEon,
        tertiary: cyanSpirit,
        error: crimsonAura,
        surface: deepNight,
        onPrimary: Colors.white,
        onSecondary: obsidian,
        onSurface: paperBeige,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: paperBeige,
        displayColor: goldEon,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepNight,
        foregroundColor: paperBeige,
        elevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: violetArcane,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: deepNight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: goldEon, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
