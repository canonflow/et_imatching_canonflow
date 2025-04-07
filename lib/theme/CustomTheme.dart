import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.sourceSans3().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: const Color(0xff38608f),
        onPrimary: const Color(0xffffffff),
        primaryContainer: const Color(0xffd2e4ff),
        onPrimaryContainer: const Color(0xff1c4875),
        surfaceDim: const Color(0xffd8dae0),
        secondary: const Color(0xff535f70),
        onSecondary: const Color(0xffffffff),
        secondaryContainer: const Color(0xffd7e3f8),
        onSecondaryContainer: const Color(0xff3c4858),
        surface: const Color(0xfff8f9ff),
        tertiary: const Color(0xff6c5778),
        onTertiary: const Color(0xffffffff),
        tertiaryContainer: const Color(0xfff4daff),
        onTertiaryContainer: const Color(0xff533f5f),
        surfaceBright: const Color(0xfff8f9ff),
        error: const Color(0xffba1a1a),
        onError: const Color(0xffffffff),
        errorContainer: const Color(0xffffdad6),
        onErrorContainer: const Color(0xff93000a),
        inverseSurface: const Color(0xff2e3035),
        onInverseSurface: const Color(0xffeff0f7),
        inversePrimary: const Color(0xffa2c9fe),
        scrim: const Color(0xff000000),
        shadow: const Color(0xff000000),
        onSurface: const Color(0xff191c20),
        onSurfaceVariant: const Color(0xff43474e),
        outline: const Color(0xff73777f),
        outlineVariant: const Color(0xffc3c6cf),
        surfaceContainerLowest: const Color(0xffffffff),
        surfaceContainerLow: const Color(0xfff2f3fa),
        surfaceContainer: const Color(0xffeceef4),
        surfaceContainerHigh: const Color(0xffe7e8ee),
        surfaceContainerHighest: const Color(0xffe1e2e8)
      )
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: const Color(0xffa2c9fe),
            onPrimary: const Color(0xff00325a),
            primaryContainer: const Color(0xff1c4875),
            onPrimaryContainer: const Color(0xffd2e4ff),
            surfaceDim: const Color(0xff111418),
            secondary: const Color(0xffbbc7db),
            onSecondary: const Color(0xff253141),
            secondaryContainer: const Color(0xff3c4858),
            onSecondaryContainer: const Color(0xffd7e3f8),
            surface: const Color(0xff111418),
            tertiary: const Color(0xffd8bde4),
            onTertiary: const Color(0xff3c2947),
            tertiaryContainer: const Color(0xff533f5f),
            onTertiaryContainer: const Color(0xfff4daff),
            surfaceBright: const Color(0xff37393e),
            error: const Color(0xffffb4ab),
            onError: const Color(0xff690005),
            errorContainer: const Color(0xff93000a),
            onErrorContainer: const Color(0xffffdad6),
            inverseSurface: const Color(0xffe1e2e8),
            onInverseSurface: const Color(0xff2e3035),
            inversePrimary: const Color(0xff38608f),
            scrim: const Color(0xff000000),
            shadow: const Color(0xff000000),
            onSurface: const Color(0xffe1e2e8),
            onSurfaceVariant: const Color(0xffc3c6cf),
            outline: const Color(0xff8d9199),
            outlineVariant: const Color(0xff43474e),
            surfaceContainerLowest: const Color(0xff0b0e13),
            surfaceContainerLow: const Color(0xff191c20),
            surfaceContainer: const Color(0xff1d2024),
            surfaceContainerHigh: const Color(0xff272a2f),
            surfaceContainerHighest: const Color(0xff32353a)
        )
    );
  }
}