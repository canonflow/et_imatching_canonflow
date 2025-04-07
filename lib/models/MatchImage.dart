import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

class MatchImage{
  String image;
  String name;
  bool isOpen;
  late GlobalKey<FlipCardState> flipKey;

  // MatchImage({
  //   required this.image,
  //   required this.name,
  //   this.isOpen = false,
  // }) : flipKey = GlobalKey<FlipCardState>();

  MatchImage({
    required this.image,
    required this.name,
    this.isOpen = false,
  }) {
    flipKey = GlobalKey<FlipCardState>();
  }
}

/** Max Image => 12 (for 3x4)
 * Level 1 (2x2) => needs 2 pairs
 * Level 2 (2x4) => needs 4 pairs
 * level 3 (3x4) => needs 6 pairs
 */

var images = <MatchImage>[
  MatchImage(image: "./assets/images/apple.png", name: "Apple"),
  MatchImage(image: "./assets/images/banana.png", name: "Banana"),
  MatchImage(image: "./assets/images/cherry.png", name: "Cherry"),
  MatchImage(image: "./assets/images/orange.png", name: "Orange"),
  MatchImage(image: "./assets/images/strawberry.png", name: "Strawberry"),
  MatchImage(image: "./assets/images/watermelon.png", name: "Watermelon"),
];

List<MatchImage> getImages(int level) {
  // List<MatchImage> copy = images.take(level * 2).toList();
  // List<MatchImage> duplicated = [...copy, ...copy];
  //
  // duplicated.shuffle(Random());

  List<MatchImage> copy = List.from(images)..shuffle(Random());
  copy = copy.take(level * 2).toList();

  List<MatchImage> duplicated = [...copy, ...copy];
  duplicated.shuffle(Random());

  // return duplicated;
  return duplicated.map((img) => MatchImage(
    image: img.image,
    name: img.name,
  )..flipKey = GlobalKey<FlipCardState>()).toList();
}

