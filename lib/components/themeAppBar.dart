import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';

AppBar themeAppBar(
  BuildContext context,
  String title,
  ThemeProvider themeProvider,
  [Color? backgroundColor]
) {
  return AppBar(
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    title: Text(title),
    actions: [
      IconButton(
          onPressed: () {
            if (themeProvider.currentTheme == ThemeEnum.LIGHT) {
              themeProvider.changeTheme(ThemeEnum.DARK);
            }
            else {
              themeProvider.changeTheme(ThemeEnum.LIGHT);
            }
          },
          icon: Icon(
              themeProvider.currentTheme == ThemeEnum.LIGHT
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded
          )
      )
    ],
  );
}