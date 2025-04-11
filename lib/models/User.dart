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

  // Find User's High Score
  Future<int?> FindHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final String? highscoresJson = await prefs.getString(LocalStorageKey.HIGHSCORES);

    if (highscoresJson == null) return null;

    // Decode
    List<String> highscoresListMap = jsonDecode(highscoresJson);

    // Convert into list of user
    List<User> highscores = highscoresListMap
      .map((json) => User.fromJson(jsonDecode(json)))
      .toList();

    // return highscores
    //     .where((user) => user.username == username)
    //     .firstOrNull;

    final match = highscores.where((user) => user.username == username);

    return match.isNotEmpty ? match.first.score : null;
  }

  // Save User's High Score
  Future<void> SaveHighScore() async {
    final prefs = await SharedPreferences.getInstance();

    final String? highscoresJson = await prefs.getString(LocalStorageKey.HIGHSCORES);

    // Kalo blm ada yg main
    if (highscoresJson == null) {
      List<User> highscores = [User(username: username)];
      List<String> highscoresJson = highscores
        .map((user) => jsonEncode(user.toJson()))
        .toList();

      await prefs.setStringList(LocalStorageKey.HIGHSCORES, highscoresJson);
    } else {
      // Kalo udh ada yg main
      // Cek apakah sudah pernah main sebelumnya

      // Convert into list of user
      List<String> highscoresListMap = jsonDecode(highscoresJson);
      List<User> highscores = highscoresListMap
          .map((json) => User.fromJson(jsonDecode(json)))
          .toList();

      final match = highscores
        .where((user) => user.username == username);

      if (match.isNotEmpty) {
        // Udh pernah main
        User user = match.first;
        user.score = score;
        user.moves = moves;
        user.mistakes = mistakes;
      } else {
        // Belum pernah main
        highscores.add(this);
      }

      // Simpan
      final updatedJson = highscores
        .map((user) => jsonEncode(user.toJson()))
        .toList();

      await prefs.setStringList(LocalStorageKey.HIGHSCORES, updatedJson);
    }
  }

  // Get All High Scores
  static Future<List<User>?> GetAllHighscores() async {
    final prefs = await SharedPreferences.getInstance();

    final String? highscoresJson = await prefs.getString(LocalStorageKey.HIGHSCORES);

    if (highscoresJson == null) return null;

    List<String> highscoresListMap = jsonDecode(highscoresJson);
    
    List<User> highscores= highscoresListMap
      .map((user) => User.fromJson(jsonDecode(user)))
      .toList();

    return highscores;
  }
}