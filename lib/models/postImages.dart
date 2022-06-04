import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PostImage {
  final List<dynamic> urls;
  final String postId;
  final String type;

  PostImage({this.urls, this.postId, this.type,});

  Map<String, dynamic> toMap() {
    return {
      "urls": urls.join("|"),
      "postId": postId,
      "type": type
    };
  }
}

class PostImageDBManager {
  Database _database;

  Future openDB() async {
    if(_database == null)
    {
      _database = await openDatabase(
          join(await getDatabasesPath(), "images.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                "CREATE TABLE images (postId TEXT, urls TEXT PRIMARY KEY, type TEXT)"
            );
          }
      );
    }
  }

  Future<int> insertImage(PostImage postImage) async {
    await openDB();
    return await _database.insert('images', postImage.toMap());
  }

  Future<List<String>> getImages(String postId, String type) async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database
        .query('images', where: "postId=? and type=?", whereArgs: [postId, type]);
    return (maps[0]["urls"]).toString().split("|");
  }

  checkForImages(String postId, String type) async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _database
        .query('images', where: "postId=? and type=?", whereArgs: [postId, type]);


    return maps.length;
  }

}