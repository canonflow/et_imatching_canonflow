import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:et_imatching_canonflow/models/User.dart';
import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HighscoreScreen extends StatelessWidget {
  const HighscoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(
        context,
        "HighScore",
        _themeProvider,
        Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<User>?>(
          future: User.GetAllHighscores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No scores yet!'));
            }

            var sortedScores = snapshot.data!;

            // Multi-criteria sort
            sortedScores.sort((a, b) {
              // 1. Sort by score (descending)
              int scoreComparison = b.score.compareTo(a.score);
              if (scoreComparison != 0) return scoreComparison;

              // 2. Sort by mistakes (ascending)
              int mistakeComparison = a.mistakes.compareTo(b.mistakes);
              if (mistakeComparison != 0) return mistakeComparison;

              // 3. Sort by moves (ascending)
              return a.moves.compareTo(b.moves);
            });

            final topScores = sortedScores.take(3).toList();

            return ListView.builder(
              itemCount: topScores.length,
              itemBuilder: (context, index) {
                final user = topScores[index];
                return _buildScoreCard(
                  context,
                  rank: index + 1,
                  username: user.username,
                  score: user.score,
                  mistakes: user.mistakes,
                  moves: user.moves,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context, {
    required int rank,
    required String username,
    required int score,
    required int mistakes,
    required int moves,
  }) {
    final rankEmojis = ['🥇', '🥈', '🥉'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(rankEmojis[rank - 1], style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Mistakes: $mistakes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Moves: $moves',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(
                '#$rank',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
