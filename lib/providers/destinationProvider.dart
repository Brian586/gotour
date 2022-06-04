// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/admin/UploadDestinations.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DestinationProvider with ChangeNotifier {
  updateDestinationDB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String destinationsString = prefs.getString("destinations") ?? "";

    List<Destination> prefList = Destination.decode(destinationsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    int timestamp = prefList.isEmpty ? 0 : prefList.last.timestamp;

    if (timestamp == 0) {
      await destinationsReference
          .where("timestamp", isGreaterThan: timestamp)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Destination destination = Destination.fromDocument(document);

          prefList.add(destination);
        });

        final String encodedData = Destination.encode(prefList);

        await prefs.setString("destinations", encodedData);

        notifyListeners();
      });
    } else {
      await destinationsReference
          .where("timestamp", isGreaterThan: timestamp)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          Destination destination = Destination.fromDocument(document);

          prefList.add(destination);
        });

        final String encodedData = Destination.encode(prefList);

        await prefs.setString("destinations", encodedData);

        notifyListeners();
      });
    }

    //notifyListeners();
  }

  Future<List<Destination>> getDestinations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String destinationsString = prefs.getString("destinations") ?? "";

    List<Destination> prefList = Destination.decode(destinationsString);
    //var timestamp = await destinationDatabaseManager.getTimestamp('DESC');

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList.reversed.toList();
  }

  loadOldDestinations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String destinationsString = prefs.getString("destinations") ?? "";

    List<Destination> prefList = Destination.decode(destinationsString);
    //var timestamp = await destinationDatabaseManager.getTimestamp('DESC');

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var timestamp = prefList.first.timestamp;

    await destinationsReference
        .where("timestamp", isLessThan: timestamp)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Destination destination = Destination.fromDocument(document);

        prefList.add(destination);
      });

      final String encodedData = Destination.encode(prefList);

      await prefs.setString("destinations", encodedData);

      notifyListeners();
    });
  }
}
