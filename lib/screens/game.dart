import 'package:et_imatching_canonflow/models/MatchImage.dart';
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
  bool _inAnimation = false;
  late List<match_image_class.MatchImage> images;
  List<match_image_class.MatchImage> tappedCards = [];

  void initState() {
    super.initState();
    images = match_image_class.getImages(_level);
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
            first.flipKey.currentState?.toggleCard();
            second.flipKey.currentState?.toggleCard();
          }
          _inAnimation = false;

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
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2 + (_level - 1) * 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              final card = images[index];
              return FlipCard(
                key: card.flipKey,
                flipOnTouch: false,
                direction: FlipDirection.HORIZONTAL,
                // front: Container(child: Text("FRONT")),
                // back: Container(child: Text("BACK")),
                front: GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(Icons.help_outline_rounded, size: 40),
                    ),
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(card.image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
