import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Account {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String phone;
  final String role;
  final int followers;
  final int following;
  final int posts;

  Account({
    @required this.email,
    @required this.phone,
    @required this.url,
    @required this.id,
    @required this.profileName,
    this.role,
    this.followers,
    this.following,
    this.posts,
    @required this.username,
  });

  Map<String, String> toMap() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "url": url,
      "profileName": profileName,
      "phone": phone
    };
  }

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account(
      id: doc["id"],
      email: doc['email'],
      username: doc['username'],
      url: doc['url'],
      profileName: doc['profileName'],
      phone: doc['phone'],
      role: doc['role'],
      posts: doc['posts'],
      followers: doc['followers'],
      following: doc['following']
    );
  }

}

Account userX = Account(
    email: "youremail@gmail.com",
    phone: "+254700000000",
    url: "",
    id: "A6hWINGodebePR6z45eRvHecKOM2",
    profileName: "User15244",
    username: "User15244"
);


Account brian = Account(
    email: "email",
    phone: "phone",
    url: "",
    id: "A6hWINGodebePR6z45eRvHecKOM2",
    profileName: "profileName",
    username: "username"
);


Account mickey = Account(
    email: "mokayamark@gmail.com",
    phone: "0702846342",
    url: "https://firebasestorage.googleapis.com/v0/b/project-5-97d71.appspot.com/o/Profile%20Photos%2F1613044874720.jpg?alt=media&token=a460a09b-2228-44c6-acfc-7c4186dc8e11",
    id: "DUxn3LLKj4e0QF9aijMOwpf9Qlr1",
    profileName: "profileName",
    username: "mickey tours and travel"
);

class UserDataBaseManager {
  Database _userDatabase;

  Future openUserDB() async {
    if(_userDatabase == null)
      {
        _userDatabase = await openDatabase(
            join(await getDatabasesPath(), "user.db"),
            version: 1,
            onCreate: (Database db, int version) async {
              await db.execute(
                "CREATE TABLE user (id TEXT PRIMARY KEY, email TEXT, username TEXT, url TEXT, profileName TEXT, phone TEXT)"
              );
            }
        );
      }
  }

  Future<int> insertUser(Account user) async {
    await openUserDB();
    return await _userDatabase.insert('user', user.toMap());
  }

  Future<Account> getUser() async {
    int index;
    await openUserDB();
    final List<Map<String, String>> maps = await _userDatabase.query('user');//this returns a list .... set limit to 1
    return Account(
      id: maps[index]['id'],
      email: maps[index]['email'],
      username: maps[index]['username'],
      url: maps[index]['url'],
      profileName: maps[index]['profileName'],
      phone: maps[index]['phone'],
    );
  }

  Future<int> updateUserInfo(String id, String profileName, String phone) async {
    await openUserDB();
    return await _userDatabase.rawUpdate('''
    UPDATE user 
    SET profileName = ?, phone = ? 
    WHERE id = ?
    ''',
    ['$profileName', '$phone', '$id']);
  }

}