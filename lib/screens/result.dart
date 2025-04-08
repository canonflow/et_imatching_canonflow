import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final score = args['score'] ?? 0;
    final moves = args['moves'] ?? 0;
    final mistakes = args['mistakes'] ?? 0;
    final user = args['user'] ?? "No user";


    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(context, "RESULT", _themeProvider, Theme.of(context).colorScheme.surfaceContainer),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text("RESULT"),
      ),
    );
  }
}
