import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Destination {
  String destinationId;
  String imageUrl;
  String city;
  String country;
  String description;
  int timestamp;

  Destination(
      {this.imageUrl,
      this.destinationId,
      this.city,
      this.country,
      this.description,
      this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "postId": destinationId,
      "description": description,
      "imageUrl": imageUrl,
      "country": country,
      "city": city,
      "timestamp": timestamp
    };
  }

  factory Destination.fromJson(Map<String, dynamic> jsonData) {
    return Destination(
        destinationId: jsonData["postId"],
        imageUrl: jsonData["imageUrl"],
        city: jsonData["city"],
        country: jsonData["country"],
        description: jsonData["description"],
        timestamp: jsonData["timestamp"]);
  }

  factory Destination.fromDocument(DocumentSnapshot documentSnapshot) {
    return Destination(
        destinationId: documentSnapshot["postId"],
        imageUrl: documentSnapshot["url"],
        city: documentSnapshot["city"],
        country: documentSnapshot["country"],
        description: documentSnapshot["description"],
        timestamp: documentSnapshot["timestamp"]);
  }

  static String encode(List<Destination> destinations) => json.encode(
        destinations
            .map<Map<String, dynamic>>((destination) => destination.toMap())
            .toList(),
      );

  static List<Destination> decode(String destinationsString) {
    if (destinationsString.isNotEmpty) {
      return (json.decode(destinationsString) as List<dynamic>)
          .map<Destination>((item) => Destination.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}

// class DestinationDatabaseManager {
//   Database _destinationDatabase;

//   Future openDestinationDB() async {
//     if (_destinationDatabase == null) {
//       _destinationDatabase = await openDatabase(
//           join(await getDatabasesPath(), "destinations.db"),
//           version: 1, onCreate: (Database db, int version) async {
//         await db.execute(
//             "CREATE TABLE destinations (postId TEXT PRIMARY KEY, description TEXT, imageUrl TEXT, city TEXT, country TEXT, timestamp INTEGER)");
//       });
//     }
//   }

//   Future<int> insertDestination(Destination destination) async {
//     await openDestinationDB();
//     return await _destinationDatabase.insert(
//         'destinations', destination.toMap());
//   }

//   Future<List<Destination>> getDestinationList() async {
//     await openDestinationDB();
//     final List<Map<String, dynamic>> maps = await _destinationDatabase
//         .rawQuery('SELECT * FROM destinations ORDER BY timestamp DESC');
//     return List.generate(maps.length, (index) {
//       return Destination(
//           destinationId: maps[index]['postId'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['imageUrl'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           timestamp: maps[index]['timestamp']);
//     });
//   }

//   getTimestamp(String order) async {
//     await openDestinationDB();
//     final List<Map<String, dynamic>> maps = await _destinationDatabase.rawQuery(
//         'SELECT * FROM destinations ORDER BY timestamp $order LIMIT 1');

//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
// }
