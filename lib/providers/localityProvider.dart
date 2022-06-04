// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/models/LocalityModel.dart';
import 'package:gotour/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalityProvider with ChangeNotifier {
  updateLocalities(String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String localitiesString = prefs.getString("localities") ?? "";

    List<Locality> prefList = Locality.decode(localitiesString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    int timestamp = prefList
            .where((locality) =>
                locality.city == city && locality.country == country)
            .toList()
            .isEmpty
        ? 0
        : prefList
            .where((locality) =>
                locality.city == city && locality.country == country)
            .toList()
            .last
            .timestamp;

    await localityReference
        .where("city", isEqualTo: city)
        .where("country", isEqualTo: country)
        .where("timestamp", isGreaterThan: timestamp)
        .orderBy("timestamp", descending: false)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Locality locality = Locality.fromDocument(document);

        prefList.add(locality);
      });

      final String encodedData = Locality.encode(prefList);

      await prefs.setString("localities", encodedData);

      notifyListeners();
    });
  }

  Future<List<Locality>> getLocalities(String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String localitiesString = prefs.getString("localities") ?? "";

    List<Locality> prefList = Locality.decode(localitiesString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList
        .where(
            (locality) => locality.city == city && locality.country == country)
        .toList()
        .reversed
        .toList();
  }
}
