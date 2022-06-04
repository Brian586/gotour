// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
//import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Category {
  final String name;
  final String imageUrl;
  final int timestamp;

  Category({this.name, this.imageUrl, this.timestamp});

  Map<String, dynamic> toMap() {
    return {"name": name, "url": imageUrl, "timestamp": timestamp};
  }

  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category(
        name: jsonData["name"],
        imageUrl: jsonData["url"],
        timestamp: jsonData["timestamp"]);
  }

  factory Category.fromDocument(DocumentSnapshot documentSnapshot) {
    return Category(
        name: documentSnapshot["name"],
        imageUrl: documentSnapshot["url"],
        timestamp: documentSnapshot["timestamp"]);
  }

  static String encode(List<Category> categories) => json.encode(
        categories
            .map<Map<String, dynamic>>((category) => category.toMap())
            .toList(),
      );

  static List<Category> decode(String categories) {
    if (categories.isNotEmpty) {
      return (json.decode(categories) as List<dynamic>)
          .map<Category>((item) => Category.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}

// class CategoryDatabaseManager {
//   Database _categoryDatabase;

//   Future openCategoryDB() async {
//     if (_categoryDatabase == null) {
//       _categoryDatabase = await openDatabase(
//           join(await getDatabasesPath(), "category.db"),
//           version: 1, onCreate: (Database db, int version) async {
//         await db.execute(
//             "CREATE TABLE category (timestamp INTEGER PRIMARY KEY, name TEXT, url TEXT)");
//       });
//     }
//   }

//   Future<int> insertCategory(Category category) async {
//     await openCategoryDB();
//     return await _categoryDatabase.insert("category", category.toMap());
//   }

//   Future<List<Category>> getAllCategories() async {
//     await openCategoryDB();
//     final List<Map<String, dynamic>> maps =
//         await _categoryDatabase.query("category");
//     return List.generate(maps.length, (index) {
//       return Category(
//           name: maps[index]['name'],
//           imageUrl: maps[index]['url'],
//           timestamp: maps[index]['timestamp']);
//     });
//   }

//   Future<List<Category>> getCategoryList(String limit, String order) async {
//     await openCategoryDB();
//     final List<Map<String, dynamic>> maps = await _categoryDatabase.rawQuery(
//         'SELECT * FROM category ORDER BY timestamp $order LIMIT $limit');
//     return List.generate(maps.length, (index) {
//       return Category(
//           name: maps[index]['name'],
//           imageUrl: maps[index]['url'],
//           timestamp: maps[index]['timestamp']);
//     });
//   }

//   getTimestamp() async {
//     await openCategoryDB();
//     final List<Map<String, dynamic>> maps = await _categoryDatabase
//         .rawQuery('SELECT * FROM category ORDER BY timestamp DESC LIMIT 1');

//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
// }
