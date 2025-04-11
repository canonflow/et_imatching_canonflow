import 'dart:convert';

import 'package:et_imatching_canonflow/constants/LocalStorageKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  int mistakes;
  int moves;
  int score;

  User({ required this.username, this.mistakes = 0, this.moves = 0, this.score = 0});

  // Convert JSON to Class
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      mistakes: json['mistakes'],
      moves: json['moves'],
      score: json['score']
    );
  }

  // Convert Class to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'mistakes': mistakes,
      'moves': moves,
      'score': score
    };
  }

  // Get Currently Logged-In User
  static Future<User?> get() async {
    final prefs = await SharedPreferences.getInstance();

    final String? userJson = prefs.getString(LocalStorageKey.USERNAME);

    User? user;

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      user = User.fromJson(userMap);
    }

    return user;
  }

  // Save to Shared Preferences
  Future<void> saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(toJson());

    prefs.setString(LocalStorageKey.USERNAME, userJson);
  }
}