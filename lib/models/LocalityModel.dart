// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class Locality {
  String destinationId;
  String imageUrl;
  String locality;
  String city;
  String country;
  String description;
  int timestamp;

  Locality({
    this.imageUrl,
    this.destinationId,
    this.locality,
    this.city,
    this.country,
    this.timestamp,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "postId": destinationId,
      "description": description,
      "url": imageUrl,
      "locality": locality,
      "country": country,
      "city": city,
      "timestamp": timestamp
    };
  }

  factory Locality.fromJson(Map<String, dynamic> documentSnapshot) {
    return Locality(
        destinationId: documentSnapshot["postId"],
        imageUrl: documentSnapshot["url"],
        city: documentSnapshot["city"],
        locality: documentSnapshot["locality"],
        country: documentSnapshot["country"],
        description: documentSnapshot["description"],
        timestamp: documentSnapshot["timestamp"]);
  }

  factory Locality.fromDocument(DocumentSnapshot documentSnapshot) {
    return Locality(
        destinationId: documentSnapshot["postId"],
        imageUrl: documentSnapshot["url"],
        city: documentSnapshot["city"],
        locality: documentSnapshot["locality"],
        country: documentSnapshot["country"],
        description: documentSnapshot["description"],
        timestamp: documentSnapshot["timestamp"]);
  }

  static String encode(List<Locality> localities) => json.encode(
        localities
            .map<Map<String, dynamic>>((locality) => locality.toMap())
            .toList(),
      );

  static List<Locality> decode(String localitiesString) {
    if (localitiesString.isNotEmpty) {
      return (json.decode(localitiesString) as List<dynamic>)
          .map<Locality>((item) => Locality.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}

// class LocalityDatabaseManager {
//   Database _localityDataBase;

//   Future openLocalityDB() async {
//     if(_localityDataBase == null)
//       {
//         _localityDataBase = await openDatabase(
//             join(await getDatabasesPath(), "locality.db"),
//             version: 1,
//             onCreate: (Database db, int version) async {
//               await db.execute(
//                   "CREATE TABLE locality (postId TEXT PRIMARY KEY, locality TEXT, description TEXT, url TEXT, city TEXT, country TEXT, timestamp INTEGER)"
//               );
//             }
//         );
//       }
//   }

//   Future<int> insertLocality(Locality locality) async {
//     await openLocalityDB();
//     return await _localityDataBase.insert('locality', locality.toMap());
//   }

//   Future<List<Locality>> getLocalities(String city, String country) async {
//     await openLocalityDB();
//     final List<Map<String, dynamic>> maps = await _localityDataBase
//         .rawQuery('SELECT * FROM locality WHERE city=? and country=? ORDER BY timestamp DESC',
//         ['$city', '$country']);
//     return List.generate(maps.length, (index) {
//       return Locality(
//           destinationId: maps[index]['postId'],
//           description: maps[index]['description'],
//           locality: maps[index]['locality'],
//           imageUrl: maps[index]['url'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           timestamp: maps[index]['timestamp']
//       );
//     });
//   }

//   getTimestamp(String city, String country) async {
//     await openLocalityDB();
//     final List<Map<String, dynamic>> maps = await _localityDataBase
//         .rawQuery('SELECT * FROM locality WHERE city=? and country=? ORDER BY timestamp DESC LIMIT 1',
//         ['$city', '$country']
//     );


//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }

// }
