// ignore_for_file: file_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class CarouselImages {
  final List<dynamic> urls;
  final int timestamp;

  CarouselImages({this.urls, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "timestamp": timestamp,
      "urls": urls,//.join("|"),
    };
  }

  factory CarouselImages.fromJson(Map<String, dynamic> jsonData) {
    return CarouselImages(
        urls: jsonData['urls'], timestamp: jsonData['timestamp']);
  }

  factory CarouselImages.fromDocument(DocumentSnapshot doc) {
    return CarouselImages(urls: doc['urls'], timestamp: doc['timestamp']);
  }

  static String encode(List<CarouselImages> carouselImages) => json.encode(
        carouselImages
            .map<Map<String, dynamic>>((carouselImage) => carouselImage.toMap())
            .toList(),
      );

  static List<CarouselImages> decode(String carouselImages) {
    if (carouselImages.isNotEmpty) {
      return (json.decode(carouselImages) as List<dynamic>)
          .map<CarouselImages>((item) => CarouselImages.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}

List<String> info = [
  "Find New and Exciting Places to visit!",
  "Search from our multiple categories!",
  "Gotour \nExplore, Discover, Connect"
];

// class CarouselDatabaseManager {
//   Database _carouselDatabase;

//   Future openDB() async {
//     if(_carouselDatabase == null)
//     {
//       _carouselDatabase = await openDatabase(
//           join(await getDatabasesPath(), "carousel.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE carousel (timestamp INTEGER PRIMARY KEY, urls TEXT)"
//             );
//           }
//       );
//     }
//   }

//   Future<int> insertCarousel(CarouselImages images) async {
//     await openDB();
//     return await _carouselDatabase.insert('carousel', images.toMap());
//   }

//   Future<List<CarouselImages>> getImages() async {
//     await openDB();
//     final List<Map<String, dynamic>> maps = await _carouselDatabase
//         .rawQuery('SELECT * FROM carousel ORDER BY timestamp DESC LIMIT 1');
//     return List.generate(maps.length, (index) {
//       return CarouselImages(
//         urls: (maps[index]["urls"]).toString().split("|"),
//         timestamp: maps[index]["timestamp"],
//       );
//     });
//   }

//   getTimestamp() async {
//     await openDB();
//     final List<Map<String, dynamic>> maps = await _carouselDatabase
//         .rawQuery('SELECT * FROM carousel ORDER BY timestamp DESC LIMIT 1');


//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }

// }