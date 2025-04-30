import 'dart:convert';

import 'package:et_imatching_canonflow/constants/LocalStorageKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  int mistakes;
  int moves;
  int score;

  User({
    required this.username,
    this.mistakes = 0,
    this.moves = 0,
    this.score = 0,
  });

  // Convert JSON to Class
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      mistakes: json['mistakes'],
      moves: json['moves'],
      score: json['score'],
    );
  }

  // Convert Class to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'mistakes': mistakes,
      'moves': moves,
      'score': score,
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

  // Find User's High Score
  Future<int?> FindHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? highscoresList = prefs.getStringList(
      LocalStorageKey.HIGHSCORES,
    ); // Use getStringList

    if (highscoresList == null) return null;

    // Convert JSON strings to User objects
    List<User> highscores =
        highscoresList.map((json) => User.fromJson(jsonDecode(json))).toList();

    final match = highscores.where((user) => user.username == username);
    return match.isNotEmpty ? match.first.score : null;
  }

  // Save User's High Score
  Future<void> SaveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? highscoresList = prefs.getStringList(
      LocalStorageKey.HIGHSCORES,
    ); // Use getStringList

    List<User> highscores = [];

    if (highscoresList != null) {
      // Convert JSON strings to User objects
      highscores =
          highscoresList
              .map((json) => User.fromJson(jsonDecode(json)))
              .toList();
    }

    final existingUserIndex = highscores.indexWhere(
      (user) => user.username == username,
    );

    if (existingUserIndex != -1) {
      // Update existing user's score if current score is higher
      if (score > highscores[existingUserIndex].score) {
        highscores[existingUserIndex].score = score;
        highscores[existingUserIndex].moves = moves;
        highscores[existingUserIndex].mistakes = mistakes;
      }
    } else {
      // Add new user
      highscores.add(this);
    }

    // Convert back to JSON strings
    final updatedJsonList =
        highscores.map((user) => jsonEncode(user.toJson())).toList();

    await prefs.setStringList(LocalStorageKey.HIGHSCORES, updatedJsonList);
  }

  // Get All High Scores
  static Future<List<User>?> GetAllHighscores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? highscoresList = prefs.getStringList(
      LocalStorageKey.HIGHSCORES,
    ); // Use getStringList

    if (highscoresList == null) return null;

    List<User> highscores =
        highscoresList.map((json) => User.fromJson(jsonDecode(json))).toList();

    highscores.sort((a, b) => b.score.compareTo(a.score));
    return highscores;
  }
}
