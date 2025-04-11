import 'dart:convert';

import 'package:et_imatching_canonflow/constants/LocalStorageKey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeEnum { DARK, LIGHT }

class ThemeProvider extends ChangeNotifier {
  ThemeEnum currentTheme = ThemeEnum.LIGHT;

  ThemeData? currentThemeData;

  static ThemeProvider? _instance;
  static ThemeProvider get instance {
    _instance ??= ThemeProvider._init();
    return _instance!;
  }

  ThemeProvider._init();

  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? themeStr = prefs.getString(LocalStorageKey.THEME_MODE);

    if (themeStr != null && themeStr == ThemeEnum.DARK.name) {
      await changeTheme(ThemeEnum.DARK);
    } else {
      await changeTheme(ThemeEnum.LIGHT);
    }
  }

  Future<void> changeTheme(ThemeEnum theme) async {
    currentTheme = theme;
    await _generateThemeData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalStorageKey.THEME_MODE, theme.name);

    notifyListeners();
  }

  Future<void> _generateThemeData() async {
    String themeStr = await rootBundle.loadString(_getThemeJsonPath());

    Map themeJson = jsonDecode(themeStr);
    currentThemeData = ThemeDecoder.decodeThemeData(themeJson);
  }

  String _getThemeJsonPath() {
    switch (currentTheme) {
      // case ThemeEnum.Light:
      //   return "assets/themes.theme_light.json";
      case ThemeEnum.DARK:
        return "assets/themes/theme_dark.json";
      default:
        return "assets/themes/theme_light.json";
    }
  }
}