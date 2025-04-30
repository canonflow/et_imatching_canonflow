import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:et_imatching_canonflow/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final score = args['score'] ?? 0;
    final moves = args['moves'] ?? 0;
    final mistakes = args['mistakes'] ?? 0;
    final user = args['user'] ?? "No user";

    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(
        context,
        "RESULT",
        _themeProvider,
        Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreCard(context, score),
            const SizedBox(height: 20),
            _buildStatsRow(context, moves, mistakes),
            const SizedBox(height: 30),
            _buildHighScoreSection(context, user, score),
            const Spacer(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildScoreCard(BuildContext context, int score) {
  return Card(
    elevation: 4,
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildStatsRow(BuildContext context, int moves, int mistakes) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildStatItem(
        context,
        icon: Icons.moving,
        label: 'Moves',
        value: moves.toString(),
      ),
      _buildStatItem(
        context,
        icon: Icons.error_outline,
        label: 'Mistakes',
        value: mistakes.toString(),
      ),
    ],
  );
}

Widget _buildStatItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 8),
      Text(label, style: Theme.of(context).textTheme.bodyLarge),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _buildHighScoreSection(
  BuildContext context,
  String user,
  int currentScore,
) {
  return FutureBuilder<int?>(
    future: User(username: user).FindHighScore(),
    builder: (context, snapshot) {
      final highScore = snapshot.data ?? 0;
      final isNewHighScore = currentScore > highScore;

      return Column(
        children: [
          Text(
            'Current High Score',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            isNewHighScore ? currentScore.toString() : highScore.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildActionButtons(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, // Makes buttons full-width
    children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12), // External spacing
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Play Again'),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed: () => Navigator.pushNamed(context, 'highscore'),
          child: const Text('Leaderboard'),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          onPressed:
              () => Navigator.popUntil(context, (route) => route.isFirst),
          child: const Text('Back to Home'),
        ),
      ),
    ],
  );
}
