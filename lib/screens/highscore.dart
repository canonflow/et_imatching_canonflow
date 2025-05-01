import 'dart:math';
import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:et_imatching_canonflow/models/User.dart';
import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

class HighscoreScreen extends StatefulWidget {
  const HighscoreScreen({super.key});

  @override
  State<HighscoreScreen> createState() => _HighscoreScreenState();
}

class _HighscoreScreenState extends State<HighscoreScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  final List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    for (int i = 0; i < 3; i++) {
      _itemAnimations.add(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(i * 0.3, 1.0, curve: Curves.easeOutBack),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(
        context,
        "High Score",
        Provider.of<ThemeProvider>(context),
        Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Stack(
        children: [
          _buildConfetti(),
          Padding(
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

                var sortedScores = _sortScores(snapshot.data!);
                final topScores = sortedScores.take(3).toList();

                return AnimatedList(
                  initialItemCount: topScores.length,
                  itemBuilder: (context, index, animation) {
                    return _buildAnimatedScoreCard(
                      context,
                      user: topScores[index],
                      rank: index + 1,
                      animation: _itemAnimations[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
        ],
        createParticlePath: (size) => _createStarPath(size),
      ),
    );
  }

  Path _createStarPath(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2;

    final path = Path();
    final fullAngle = degToRad(360 / numberOfPoints);

    path.moveTo(size.width, halfWidth);

    for (int i = 0; i < numberOfPoints; i++) {
      path.lineTo(
        halfWidth + externalRadius * cos(fullAngle * i),
        halfWidth + externalRadius * sin(fullAngle * i),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(fullAngle * i + fullAngle / 2),
        halfWidth + internalRadius * sin(fullAngle * i + fullAngle / 2),
      );
    }

    path.close();
    return path;
  }

  Widget _buildAnimatedScoreCard(
    BuildContext context, {
    required User user,
    required int rank,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildScoreCard(
            context,
            rank: rank,
            username: user.username,
            score: user.score,
            mistakes: user.mistakes,
            moves: user.moves,
          ),
        ),
      ),
    );
  }

  List<User> _sortScores(List<User> scores) {
    return scores..sort((a, b) {
      int scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) return scoreComparison;
      int mistakeComparison = a.mistakes.compareTo(b.mistakes);
      if (mistakeComparison != 0) return mistakeComparison;
      return a.moves.compareTo(b.moves);
    });
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
    final rankColors = [
      const Color(0xFFFFD700),
      const Color(0xFFC0C0C0),
      const Color(0xFFCD7F32),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: rankColors[rank - 1].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rankEmojis[rank - 1],
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(context, 'Score', score.toString()),
                    _buildStatRow(context, 'Mistakes', mistakes.toString()),
                    _buildStatRow(context, 'Moves', moves.toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: rankColors[rank - 1].withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#$rank',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: rankColors[rank - 1],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
