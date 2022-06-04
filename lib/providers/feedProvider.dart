// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedProvider with ChangeNotifier {
  // Future get futureFeed => _futureFeed;
  //
  // FeedDatabaseManager feedDatabaseManager = FeedDatabaseManager();
  //
  // final Future _futureFeed = FeedDatabaseManager().getFeed();

  deletePref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  updateFeedDB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String feedString = prefs.getString("feed") ?? "";

    List<Feed> prefList = Feed.decode(feedString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var feedTimestamp = prefList.isEmpty ? 0 : prefList.last.timestamp;

    if (feedTimestamp == 0) {
      await feedReference
          .where("timestamp", isGreaterThan: feedTimestamp)
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          Feed feed = Feed.fromDocument(document);

          prefList.add(feed);
        });

        final String encodedData = Feed.encode(prefList);

        await prefs.setString("feed", encodedData);

        notifyListeners();
      });
    } else {
      await feedReference
          .where("timestamp", isGreaterThan: feedTimestamp)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          Feed feed = Feed.fromDocument(document);

          prefList.add(feed);
        });

        final String encodedData = Feed.encode(prefList);

        await prefs.setString("feed", encodedData);

        notifyListeners();
      });
    }

    //notifyListeners();
  }

  updateUserPost(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String feedString = prefs.getString("userFeed") ?? "";

    List<Feed> prefList = Feed.decode(feedString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var feedTimestamp = prefList.last.timestamp;

    if (feedTimestamp == 0) {
      await feedReference
          .where("publisherID", isEqualTo: userId)
          //.where("timestamp", isGreaterThan: lastUserPost)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          Feed feed = Feed.fromDocument(document);

          prefList.add(feed);
        });

        final String encodedData = Feed.encode(prefList);

        await prefs.setString("userFeed", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("publisherID", isEqualTo: userId)
          .where("timestamp", isGreaterThan: feedTimestamp)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Feed feed = Feed.fromDocument(document);

          prefList.add(feed);
        });

        final String encodedData = Feed.encode(prefList);

        await prefs.setString("userFeed", encodedData);

        notifyListeners();
      });
    }
  }

  loadOldUserFeed(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String feedString = prefs.getString("userFeed") ?? "";

    List<Feed> prefList = Feed.decode(feedString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var feedTimestamp = prefList.first.timestamp;

    await feedReference
        .where("publisherID", isEqualTo: userId)
        .where("timestamp", isLessThan: feedTimestamp)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        Feed feed = Feed.fromDocument(document);

        prefList.add(feed);
      });

      final String encodedData = Feed.encode(prefList);

      await prefs.setString("userFeed", encodedData);

      notifyListeners();
    });
  }

  Future<List<Feed>> getFeedPosts(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String feedString = prefs.getString(key) ?? "";

    List<Feed> prefList = Feed.decode(feedString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList.reversed.toList();
  }

  loadOldFeed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String feedString = prefs.getString("feed") ?? "";

    List<Feed> prefList = Feed.decode(feedString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var feedTimestamp = prefList.first.timestamp;

    //var feedTimestamp = await feedDatabaseManager.getTimestamp('ASC');

    await feedReference
        .where("timestamp", isLessThan: feedTimestamp)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        Feed feed = Feed.fromDocument(document);

        prefList.add(feed);
      });

      final String encodedData = Feed.encode(prefList);

      await prefs.setString("feed", encodedData);

      notifyListeners();
    });

    //notifyListeners();
  }
}
