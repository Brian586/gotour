import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Feed {
  final List<dynamic> urls;
  final String postId;
  final int timestamp;
  final String description;
  final String location;
  final String username;
  final String publisherID;
  final String ownerUrl;

  Feed({this.urls, this.postId, this.timestamp, this.description, this.location, this.username, this.publisherID, this.ownerUrl});

  Map<String, dynamic> toMap() {
    return {
      "urls": urls,//.join("|"),
      "postId": postId,
      "timestamp": timestamp,
      "description": description,
      "location": location,
      "username": username,
      "publisherID": publisherID,
      "ownerUrl": ownerUrl,
    };
  }

  factory Feed.fromJson(Map<String, dynamic> doc) {
    return Feed(
        urls: doc["urls"],
        postId: doc["postId"],
        timestamp: doc["timestamp"],
        description: doc["description"],
        location: doc["location"],
        username: doc["username"],
        publisherID: doc["publisherID"],
        ownerUrl: doc["ownerUrl"]
    );
  }

  factory Feed.fromDocument(DocumentSnapshot doc) {
    return Feed(
      urls: doc["urls"],
      postId: doc["postId"],
      timestamp: doc["timestamp"],
      description: doc["description"],
      location: doc["location"],
      username: doc["username"],
      publisherID: doc["publisherID"],
      ownerUrl: doc["ownerUrl"]
    );
  }

  static String encode(List<Feed> feedItems) => json.encode(
    feedItems.map<Map<String, dynamic>>((feed) => feed.toMap())
        .toList(),
  );

  static List<Feed> decode(String feedString) {
    if (feedString.isNotEmpty) {
      return (json.decode(feedString) as List<dynamic>)
          .map<Feed>((item) => Feed.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

}
//
// class FeedDatabaseManager {
//   Database _feedDatabase;
//   Database _userFeed;
//
//   Future openFeedDB() async {
//     if(_feedDatabase == null)
//     {
//       _feedDatabase = await openDatabase(
//           join(await getDatabasesPath(), "feed.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE feed (postId TEXT PRIMARY KEY, urls TEXT, timestamp INTEGER, description TEXT, location TEXT, username TEXT, publisherID TEXT, ownerUrl TEXT)"
//             );
//           }
//       );
//     }
//   }
//
//   Future openUserFeedDB() async {
//     if(_userFeed == null)
//     {
//       _userFeed = await openDatabase(
//           join(await getDatabasesPath(), "userFeed.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE userFeed (postId TEXT PRIMARY KEY, urls TEXT, timestamp INTEGER, description TEXT, location TEXT, username TEXT, publisherID TEXT, ownerUrl TEXT)"
//             );
//           }
//       );
//     }
//   }
//
//   Future<int> insertFeed(Feed feed) async {
//     await openFeedDB();
//     return await _feedDatabase.insert('feed', feed.toMap());
//   }
//
//   Future<int> insertUserFeed(Feed feed) async {
//     await openUserFeedDB();
//     return await _userFeed.insert('userFeed', feed.toMap());
//   }
//
//   Future<List<Feed>> getFeed() async {
//     await openFeedDB();
//     final List<Map<String, dynamic>> maps = await _feedDatabase
//         .rawQuery('SELECT * FROM feed ORDER BY timestamp DESC');
//     return List.generate(maps.length, (index) {
//       return Feed(
//         postId: maps[index]["postId"],
//         urls: (maps[index]["urls"]).toString().split("|"),
//         timestamp: maps[index]["timestamp"],
//         description: maps[index]["description"],
//         location: maps[index]["location"],
//         username: maps[index]["username"],
//         publisherID: maps[index]["publisherID"],
//         ownerUrl: maps[index]["ownerUrl"],
//       );
//     });
//   }
//
//   Future<List<Feed>> getUserFeed(String userId) async {
//     await openUserFeedDB();
//     final List<Map<String, dynamic>> maps = await _userFeed
//         .rawQuery('SELECT * FROM userFeed WHERE publisherID=? ORDER BY timestamp DESC', [userId]);
//     return List.generate(maps.length, (index) {
//       return Feed(
//         postId: maps[index]["postId"],
//         urls: (maps[index]["urls"]).toString().split("|"),
//         timestamp: maps[index]["timestamp"],
//         description: maps[index]["description"],
//         location: maps[index]["location"],
//         username: maps[index]["username"],
//         publisherID: maps[index]["publisherID"],
//         ownerUrl: maps[index]["ownerUrl"],
//       );
//     });
//   }
//
//   getTimestamp(String order) async {
//     await openFeedDB();
//     final List<Map<String, dynamic>> maps = await _feedDatabase
//         .rawQuery('SELECT * FROM feed ORDER BY timestamp $order LIMIT 1');
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//   getUserFeedTimestamp(String userId, String order) async {
//     await openUserFeedDB();
//     final List<Map<String, dynamic>> maps = await _userFeed
//         .rawQuery('SELECT * FROM userFeed WHERE publisherID=? ORDER BY timestamp $order LIMIT 1', [userId]);
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//
//   clearTable() async {
//     await openFeedDB();
//     await _feedDatabase.delete('feed');
//   }
//}