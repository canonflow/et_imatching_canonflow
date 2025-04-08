import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("IN GAME"),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text("RESULT"),
      ),
    );
  }
}
