import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: "PopPins",
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1F1A1D)),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 66, 62, 147)),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD21D35)),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD21D35)),
            borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Color(0xFF1F1A1D)),
        labelStyle: const TextStyle(
          color: Color(0xFF1F1A1D),
        ),
      ),
      textTheme: const TextTheme(displayLarge: TextStyle(color: Colors.amber)));

  static final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: "PopPins",
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFEAE0E3)),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 183, 172, 255)),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 171, 175, 255)),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFFB4AB)),
            borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Color(0xFFEAE0E3)),
        labelStyle: const TextStyle(
          color: Color(0xFFEAE0E3),
        ),
      ),
      textTheme: const TextTheme(displayLarge: TextStyle(color: Colors.amber)));
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006397),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFCCE5FF),
  onPrimaryContainer: Color(0xFF001D31),
  secondary: Color(0xFF006876),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFA2EFFF),
  onSecondaryContainer: Color(0xFF001F25),
  tertiary: Color(0xFF0261A3),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD1E4FF),
  onTertiaryContainer: Color(0xFF001D36),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFCFCFF),
  onBackground: Color(0xFF1A1C1E),
  surface: Color(0xFFFCFCFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFDEE3EB),
  onSurfaceVariant: Color(0xFF42474E),
  outline: Color(0xFF72787E),
  onInverseSurface: Color(0xFFF0F0F4),
  inverseSurface: Color(0xFF2F3133),
  inversePrimary: Color(0xFF93CCFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006397),
  outlineVariant: Color(0xFFC2C7CE),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF93CCFF),
  onPrimary: Color(0xFF003351),
  primaryContainer: Color(0xFF004B73),
  onPrimaryContainer: Color(0xFFCCE5FF),
  secondary: Color(0xFF51D7EF),
  onSecondary: Color(0xFF00363E),
  secondaryContainer: Color(0xFF004E5A),
  onSecondaryContainer: Color(0xFFA2EFFF),
  tertiary: Color(0xFF9ECAFF),
  onTertiary: Color(0xFF003258),
  tertiaryContainer: Color(0xFF00497D),
  onTertiaryContainer: Color(0xFFD1E4FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1C1E),
  onBackground: Color(0xFFE2E2E5),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFE2E2E5),
  surfaceVariant: Color(0xFF42474E),
  onSurfaceVariant: Color(0xFFC2C7CE),
  outline: Color(0xFF8C9198),
  onInverseSurface: Color(0xFF1A1C1E),
  inverseSurface: Color(0xFFE2E2E5),
  inversePrimary: Color(0xFF006397),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF93CCFF),
  outlineVariant: Color(0xFF42474E),
  scrim: Color(0xFF000000),
);
