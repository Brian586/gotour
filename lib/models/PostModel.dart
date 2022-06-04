// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Post {
  final String postId;
  final String userId;
  final String imageUrl;
  final String name;
  final String type;
  final String address;
  final String locality;
  final String description;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int timestamp;
  final String price;
  final String currency;
  final String payPeriod;
  final String ownerUrl;
  final String email;
  final String phone;
  final String username;
  // final dynamic likes;
  // final String isLiked;

  Post({
    this.postId,
    //this.isLiked,
    this.userId,
    this.longitude,
    this.latitude,
    this.description,
    this.imageUrl,
    this.address,
    this.name,
    this.country,
    this.timestamp,
    this.city,
    this.locality,
    this.payPeriod,
    this.price,
    this.currency,
    this.type,
    this.email,
    this.ownerUrl,
    this.phone,
    this.username,
    //this.likes
  });

  Map<String, dynamic> toMap() {
    return {
      "postId" : postId,
      "ownerId": userId,
      "timestamp": timestamp,
      "username": username,
      "description": description,
      "url": imageUrl,
      "name": name,
      "type": type,
      "locality": locality,
      "currency": currency,
      "payPeriod": payPeriod,
      "price": price,
      "city": city,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "ownerUrl": ownerUrl,
      "phone": phone,
      "address": address,
      "email": email,
      //"isLiked": "false",
    };
  }

  factory Post.fromJson(Map<String, dynamic> documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      imageUrl: documentSnapshot["url"],
      description: documentSnapshot["description"],
      name: documentSnapshot["name"],
      city: documentSnapshot["city"],
      country: documentSnapshot["country"],
      locality: documentSnapshot["locality"],
      payPeriod: documentSnapshot["payPeriod"],
      price: documentSnapshot["price"],
      currency: documentSnapshot["currency"],
      type: documentSnapshot["type"],
      address: documentSnapshot["address"],
      latitude: documentSnapshot["latitude"],
      longitude: documentSnapshot["longitude"],
      username: documentSnapshot["username"],
      phone: documentSnapshot["phone"],
      ownerUrl: documentSnapshot["ownerUrl"],
      userId: documentSnapshot["ownerId"],
      email: documentSnapshot["email"],
      timestamp: documentSnapshot["timestamp"],
    );
  }


  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      imageUrl: documentSnapshot["url"],
      description: documentSnapshot["description"],
      name: documentSnapshot["name"],
      city: documentSnapshot["city"],
      country: documentSnapshot["country"],
      locality: documentSnapshot["locality"],
      payPeriod: documentSnapshot["payPeriod"],
      price: documentSnapshot["price"],
      currency: documentSnapshot["currency"],
      type: documentSnapshot["type"],
      address: documentSnapshot["address"],
      latitude: documentSnapshot["latitude"],
      longitude: documentSnapshot["longitude"],
      username: documentSnapshot["username"],
      phone: documentSnapshot["phone"],
      ownerUrl: documentSnapshot["ownerUrl"],
      userId: documentSnapshot["ownerId"],
      email: documentSnapshot["email"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  static String encode(List<Post> postList) => json.encode(
    postList
        .map<Map<String, dynamic>>((post) => post.toMap())
        .toList(),
  );

  static List<Post> decode(String postsString) {
    if (postsString.isNotEmpty) {
      return (json.decode(postsString) as List<dynamic>)
          .map<Post>((item) => Post.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

}
//
// class PostDataBaseManager {
//   Database _postsDatabase;
//   Database _userPostsDatabase;
//   Database _favouritesDatabase;
//
//   Future openPostDB() async {
//     if(_postsDatabase == null)
//     {
//       _postsDatabase = await openDatabase(
//           join(await getDatabasesPath(), "posts.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE posts (postId TEXT PRIMARY KEY, timestamp INTEGER, ownerId TEXT, longitude FLOAT, latitude FLOAT, description TEXT, url TEXT, address TEXT, name TEXT, city TEXT, country TEXT, locality TEXT, payPeriod TEXT, price TEXT, currency TEXT, type TEXT, email TEXT, ownerUrl TEXT, phone TEXT, username TEXT)"
//             );
//           }
//       );
//     }
//   }
//
//   Future openFavouritesDB() async {
//     if(_favouritesDatabase == null)
//     {
//       _favouritesDatabase = await openDatabase(
//           join(await getDatabasesPath(), "favourites.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE favourites (postId TEXT PRIMARY KEY, timestamp INTEGER, ownerId TEXT, longitude FLOAT, latitude FLOAT, description TEXT, url TEXT, address TEXT, name TEXT, city TEXT, country TEXT, locality TEXT, payPeriod TEXT, price TEXT, currency TEXT, type TEXT, email TEXT, ownerUrl TEXT, phone TEXT, username TEXT)"
//             );
//           }
//       );
//     }
//   }
//
//   Future openUserPostDB() async {
//     if(_userPostsDatabase == null)
//     {
//       _userPostsDatabase = await openDatabase(
//           join(await getDatabasesPath(), "userPosts.db"),
//           version: 1,
//           onCreate: (Database db, int version) async {
//             await db.execute(
//                 "CREATE TABLE userPosts (postId TEXT PRIMARY KEY, timestamp INTEGER, ownerId TEXT, longitude FLOAT, latitude FLOAT, description TEXT, url TEXT, address TEXT, name TEXT, city TEXT, country TEXT, locality TEXT, payPeriod TEXT, price TEXT, currency TEXT, type TEXT, email TEXT, ownerUrl TEXT, phone TEXT, username TEXT)"
//             );
//           }
//       );
//     }
//   }
//
//   Future<int> insertPost(Post post) async {
//     await openPostDB();
//     return await _postsDatabase.insert('posts', post.toMap());
//   }
//
//   Future<int> insertUserPost(Post post) async {
//     await openUserPostDB();
//     return await _userPostsDatabase.insert('userPosts', post.toMap());
//   }
//
//   Future<int> insertFavourite(Post post) async {
//     await openFavouritesDB();
//     return await _favouritesDatabase.insert('favourites', post.toMap());
//   }
//
//   Future<List<Post>> searchByType(String type, String city, String country) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE type=? and city=? and country=?',
//         ['$type', '$city', '$country']);
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           //isLiked: maps[index]['isLiked'],
//           username: maps[index]['username'],
//       );
//     });
//   }
//
//   Future<List<Post>> getDestinationPosts(String city, String country) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE city=? and country=? ORDER BY timestamp DESC',
//         ['$city', '$country']);
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//   Future<List<Post>> getLocalityPosts(String locality, String city, String country) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE locality=? and city=? and country=? ORDER BY timestamp DESC',
//         ['$locality','$city', '$country']);
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//   Future<List<Post>> filterLocalityPosts(String type, String locality, String city, String country) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE type=? and locality=? and city=? and country=? ORDER BY timestamp DESC',
//         ['$type','$locality','$city', '$country']);
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//
//   getLastCategoryPost(String categoryType, String order) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE type=? ORDER BY timestamp $order LIMIT 1',
//         ['$categoryType',]);
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//   Future<List<Post>> getCategoryPosts(String categoryType) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE type=? ORDER BY timestamp DESC',
//         ['$categoryType',]);
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//
//   Future<List<Post>> getPosts(String type) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps1 = await _postsDatabase
//         .query("posts");
//
//     final List<Map<String, dynamic>> maps2 = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE type="$type" ORDER BY timestamp DESC');
//
//     final List<Map<String, dynamic>> maps = type == "" ? maps1 : maps2;
//
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//   Future<List<Post>> getFavourites() async {
//     await openFavouritesDB();
//     final List<Map<String, dynamic>> maps = await _favouritesDatabase
//         .rawQuery('SELECT * FROM favourites ORDER BY timestamp DESC');
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           //isLiked: maps[index]['isLiked'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//   Future<bool> checkFavourite(String postId) async {
//     await openFavouritesDB();
//     final List<Map<String, dynamic>> maps = await _favouritesDatabase.query(
//         'favourites',
//         where: "postId = ?", whereArgs: [postId]
//     );
//
//     return maps.length > 0 ? true : false;
//   }
//
//
//   Future<List<Post>> getUserPosts(String userId) async {
//     await openUserPostDB();
//     final List<Map<String, dynamic>> maps = await _userPostsDatabase
//         .rawQuery('SELECT * FROM userPosts WHERE ownerId=? ORDER BY timestamp DESC', [userId]);
//     return List.generate(maps.length, (index) {
//       return Post(
//           postId: maps[index]['postId'],
//           userId: maps[index]['ownerId'],
//           longitude: maps[index]['longitude'],
//           latitude: maps[index]['latitude'],
//           description: maps[index]['description'],
//           imageUrl: maps[index]['url'],
//           address: maps[index]['address'],
//           name: maps[index]['name'],
//           timestamp: maps[index]['timestamp'],
//           country: maps[index]['country'],
//           city: maps[index]['city'],
//           locality: maps[index]['locality'],
//           payPeriod: maps[index]['payPeriod'],
//           price: maps[index]['price'],
//           currency: maps[index]['currency'],
//           //isLiked: maps[index]['isLiked'],
//           type: maps[index]['type'],
//           email: maps[index]['email'],
//           ownerUrl: maps[index]['ownerUrl'],
//           phone: maps[index]['phone'],
//           username: maps[index]['username']
//       );
//     });
//   }
//
//
//   Future<void> deleteFavourite(String postId) async {
//     await openFavouritesDB();
//     await _favouritesDatabase.delete(
//         'favourites',
//         where: "postId = ?", whereArgs: [postId]
//     );
//   }
//
//   Future<void> deletePost(String postId) async {
//     await openUserPostDB();
//     await _userPostsDatabase.delete(
//         'userPosts',
//         where: "postId = ?", whereArgs: [postId]
//     );
//
//     await openPostDB();
//     await _postsDatabase.delete(
//       'posts',
//         where: "postId = ?", whereArgs: [postId]
//     );
//   }
//
//   clearTable() async {
//     await openPostDB();
//     await _postsDatabase.delete('posts');
//   }
//
//   getTimestamp() async {//This gets the latest document
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts ORDER BY timestamp DESC LIMIT 1');
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//   getLatestDestinationPost(String city, String country, String order) async {
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE city=? and country=? ORDER BY timestamp $order LIMIT 1',
//       ['$city', '$country']
//     );
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//   getLatestLocalityPost(String locality, String city, String country, String order) async {//This gets the latest document
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase
//         .rawQuery('SELECT * FROM posts WHERE locality=? and city=? and country=? ORDER BY timestamp $order LIMIT 1',
//         ['$locality','$city', '$country']
//     );
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//
//   getOldPosts() async {//This gets the oldest document
//     await openPostDB();
//     final List<Map<String, dynamic>> maps = await _postsDatabase.rawQuery('SELECT * FROM posts ORDER BY timestamp ASC LIMIT 1');
//
//     return maps.length == 0 ? DateTime.now().millisecondsSinceEpoch : maps[0]['timestamp'];
//   }
//
//
//   getLastUserPost(String userId, String order) async {
//     await openUserPostDB();
//     final List<Map<String, dynamic>> maps = await _userPostsDatabase
//         .rawQuery('SELECT * FROM userPosts WHERE ownerId=? ORDER BY timestamp $order LIMIT 1',
//       [userId]
//     );
//
//
//     return maps.length == 0 ? 0 : maps[0]['timestamp'];
//   }
//
//   Future<int> updatePost(double latitude, double longitude, String postId) async {
//     await openPostDB();
//     return await _postsDatabase.rawUpdate('''
//     UPDATE posts
//     SET latitude = ?, longitude = ?
//     WHERE postId = ?
//     ''',
//         [latitude, longitude, postId]);
//   }
//}