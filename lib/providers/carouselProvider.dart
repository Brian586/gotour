// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/carouselImage.dart';
import 'package:gotour/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarouselProvider with ChangeNotifier {
  // Future<List<CarouselImages>> _futureCarousel = getCarouselList();

  // Future<List<CarouselImages>> get future => _futureCarousel;

  // CarouselDatabaseManager carouselDatabaseManager = CarouselDatabaseManager();

  // final Future _futureCarousel = CarouselDatabaseManager().getImages();

  updateCarousel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<CarouselImages> carouselList = [];

    final String carouselImagesString = prefs.getString("carouselImages") ?? "";

    List<CarouselImages> prefList = CarouselImages.decode(carouselImagesString);

    //var time = await carouselDatabaseManager.getTimestamp();

    if (carouselImagesString == "" || prefList.isEmpty) {
      await carouselReference
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        querySnapshot.docs.forEach((document) {
          CarouselImages images = CarouselImages.fromDocument(document);
          carouselList.add(images);
        });

        final String encodedData = CarouselImages.encode(carouselList);

        await prefs.setString("carouselImages", encodedData);

        notifyListeners();
      });
    } else {
      prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      int time = prefList.isEmpty ? 0 : prefList.last.timestamp;

      await carouselReference
          .where("timestamp", isGreaterThan: time)
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          CarouselImages images = CarouselImages.fromDocument(document);

          prefList.add(images);
        });

        final String encodedData = CarouselImages.encode(prefList);

        await prefs.setString("carouselImages", encodedData);

        notifyListeners();
      });
    }

    //notifyListeners();
  }

  Future<List<CarouselImages>> getCarouselList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String carouselImagesString = prefs.getString("carouselImages") ?? "";

    List<CarouselImages> prefList = CarouselImages.decode(carouselImagesString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    //prefList.reversed;

    return prefList;
  }
}
