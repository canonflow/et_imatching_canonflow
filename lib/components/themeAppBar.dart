import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';

AppBar themeAppBar(
  BuildContext context,
  String title,
  ThemeProvider _themeProvider,
  [Color? backgroundColor]
) {
  return AppBar(
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    title: Text(title),
    actions: [
      IconButton(
          onPressed: () {
            if (_themeProvider.currentTheme == ThemeEnum.LIGHT) {
              _themeProvider.changeTheme(ThemeEnum.DARK);
            }
            else {
              _themeProvider.changeTheme(ThemeEnum.LIGHT);
            }
          },
          icon: Icon(
              _themeProvider.currentTheme == ThemeEnum.LIGHT
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded
          )
      )
    ],
  );
}