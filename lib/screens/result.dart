import 'package:et_imatching_canonflow/components/themeAppBar.dart';
import 'package:et_imatching_canonflow/providers/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:et_imatching_canonflow/models/User.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreScaleAnimation;
  late Animation<double> _statsOpacityAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scoreScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _statsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final score = args['score'] ?? 0;
    final moves = args['moves'] ?? 0;
    final mistakes = args['mistakes'] ?? 0;
    final user = args['user'] ?? "No user";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: themeAppBar(
        context,
        "RESULT",
        Provider.of<ThemeProvider>(context),
        Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScaleTransition(
              scale: _scoreScaleAnimation,
              child: _buildScoreCard(context, score),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _statsOpacityAnimation,
              child: _buildStatsRow(context, moves, mistakes),
            ),
            const SizedBox(height: 30),
            _buildHighScoreSection(context, user, score),
            const Spacer(),
            SlideTransition(
              position: _buttonSlideAnimation,
              child: _buildActionButtons(context),
            ),
          ],
        ),
      ),
    );
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

  // Add particle animation for new high score
  Widget _buildHighScoreSection(BuildContext context, String user, int currentScore) {
    return FutureBuilder<int?>(
      future: User(username: user).FindHighScore(),
      builder: (context, snapshot) {
        final highScore = snapshot.data ?? 0;
        final isNewHighScore = currentScore > highScore;

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Current High Score',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    key: ValueKey<int>(isNewHighScore ? currentScore : highScore),
                    isNewHighScore ? currentScore.toString() : highScore.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (isNewHighScore)
              _buildCelebrationAnimation(),
          ],
        );
      },
    );
  }

  Widget _buildCelebrationAnimation() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: const Icon(
        Icons.celebration,
        size: 40,
        color: Colors.amber,
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _statsOpacityAnimation.value)),
          child: Opacity(
            opacity: _statsOpacityAnimation.value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Add hover animation to buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAnimatedButton(context, 'Play Again', () => Navigator.pop(context)),
        _buildAnimatedButton(context, 'Leaderboard', () => Navigator.pushNamed(context, 'highscore')),
        _buildAnimatedButton(context, 'Back to Home', 
          () => Navigator.popUntil(context, (route) => route.isFirst)),
      ],
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity(),
          transformAlignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: onPressed,
            child: Text(text),
          ),
        ),
      ),
    );
  }
}