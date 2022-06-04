// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/Category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  // Future get futureCategories => _futureCategories;
  // Future get discoverResult => _discoverResult;

  // CategoryDatabaseManager categoryDatabaseManager = CategoryDatabaseManager();

  // final Future _futureCategories =
  //     CategoryDatabaseManager().getCategoryList("9", "ASC");

  // final Future _discoverResult =
  //     CategoryDatabaseManager().getCategoryList("6", "DESC");

  updateCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String categoriesString = prefs.getString("categories") ?? "";

    List<Category> prefList = Category.decode(categoriesString);
    //var lastCategory = await categoryDatabaseManager.getTimestamp();

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    int time = prefList.isEmpty ? 0 : prefList.last.timestamp;

    await FirebaseFirestore.instance
        .collection("categories")
        .where("timestamp", isGreaterThan: time)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Category category = Category.fromDocument(document);

        prefList.add(category);
      });

      final String encodedData = Category.encode(prefList);

      await prefs.setString("categories", encodedData);

      notifyListeners();
    });

    //notifyListeners();
  }

  Future<List<Category>> getCategoryList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String categoriesString = prefs.getString("categories") ?? "";

    List<Category> prefList = Category.decode(categoriesString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList;
  }
}
