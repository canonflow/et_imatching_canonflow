import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';
import 'package:et_imatching_canonflow/models/MatchImage.dart' as match_image_class;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _level = 1;
  int _score = 0;
  int _mistakes = 0;
  int _moves = 0;
  bool _inAnimation = false;

  List<match_image_class.MatchImage> tappedCards = [];
  List<int> timers = [20, 40, 60];
  late List<match_image_class.MatchImage> images;
  late int _hitung;

  void initState() {
    super.initState();
    images = match_image_class.getImages(_level);
    _hitung = timers[_level - 1];
  }

  String formatTimer(int hitung) {
    // ~/ is a truncating division operator
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  // Trigger klo berhasil selesain level 1 dan 2
  void nextLevel() {

  }

  // Trigger Timer habis, udh level 3
  void endGame() {

  }

  void onCardTap(int index) {
    match_image_class.MatchImage tapped = images[index];

    // Kalo kartu yg dipilih sudah dibuka sebelumnya
    if (tapped.isOpen || tappedCards.contains(tapped)) return;

    // Kalo lagi animasi
    if (_inAnimation) return;

    tapped.flipKey.currentState?.toggleCard(); // Buka
    tappedCards.add(tapped);

    // Kalo udh 2 yg dibuka, bandingkan
    if (tappedCards.length == 2) {
      _inAnimation = true;
      Future.delayed(Duration(milliseconds: 800), () {
        setState(() {
          match_image_class.MatchImage first = tappedCards[0];
          match_image_class.MatchImage second = tappedCards[1];

          if (first.name == second.name) {
            _score += 10;
            first.isOpen = true;
            second.isOpen = true;
          } else {
            // Tutup lagi
            _mistakes++;
            first.flipKey.currentState?.toggleCard();
            second.flipKey.currentState?.toggleCard();
          }
          _inAnimation = false;
          _moves++;

          tappedCards.clear();
        });
      });
    }
  }

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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== TIMER =====
              Card(
                color: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: Text(
                      formatTimer(_hitung),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onError
                      ),
                    ),
                  ),
                )
              ),

              SizedBox(height: 16),

              // ===== KARTU =====
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (_level < 2) ? 2 : 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 2 / 3
                ),
                itemBuilder: (context, index) {
                  final card = images[index];
                  return FlipCard(
                    key: card.flipKey,
                    flipOnTouch: false,
                    direction: FlipDirection.HORIZONTAL,
                    front: GestureDetector(
                      onTap: () => onCardTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: 40,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    back: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 6,
                            style: BorderStyle.solid
                        ),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(card.image),
                            SizedBox(height: 18),
                            Text(
                              card.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),

              SizedBox(height: 14),
              // ===== MOVES AND MISTAKES =====
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                ),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Mistakes: $_mistakes",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "Moves: $_moves",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
