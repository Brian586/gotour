

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Suggestion {

  final String username;
  final String suggestion;
  final int timestamp;

  Suggestion({this.suggestion, this.username, this.timestamp});

  factory Suggestion.fromDocument(DocumentSnapshot doc) {
    return Suggestion(
      username: doc["username"],
      suggestion: doc["suggestion"],
      timestamp: doc["timestamp"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "timestamp": timestamp,
      "suggestion": suggestion,
      "username": username,
    };
  }

}

class SuggestionDBManager {
  Database _suggestionDatabase;

  Future openSuggestionDB() async {
    if(_suggestionDatabase == null)
    {
      _suggestionDatabase = await openDatabase(
          join(await getDatabasesPath(), "suggestions.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                "CREATE TABLE suggestions (timestamp INTEGER PRIMARY KEY, suggestion TEXT, username TEXT)"
            );
          }
      );
    }
  }

  Future<int> insertSuggestion(Suggestion suggestion) async {
    await openSuggestionDB();
    return await _suggestionDatabase.insert('suggestions', suggestion.toMap());
  }

  Future<List<Suggestion>> getSuggestions() async {
    await openSuggestionDB();
    final List<Map<String, dynamic>> maps = await _suggestionDatabase
        .rawQuery('SELECT * FROM suggestions ORDER BY timestamp DESC');
    return List.generate(maps.length, (index) {
      return Suggestion(
        timestamp: maps[index]["timestamp"],
        suggestion: maps[index]["suggestion"],
        username: maps[index]["username"],
      );
    });
  }

  getTimestamp(String order) async {
    await openSuggestionDB();
    final List<Map<String, dynamic>> maps = await _suggestionDatabase
        .rawQuery('SELECT * FROM suggestions ORDER BY timestamp $order LIMIT 1');


    return maps.length == 0 ? 0 : maps[0]['timestamp'];
  }

}