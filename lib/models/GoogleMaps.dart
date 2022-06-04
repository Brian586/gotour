import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not open the map.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  static Future<void> searchByName(String name, String city, String country) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$name, $city, $country';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not open the map.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  static Future<void> openPlace(String city, String country) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$city, $country';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not open the map.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  static Future<void> openLocality(String locality, String city, String country) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$locality, $city, $country';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Fluttertoast.showToast(
          msg: 'Could not open the map.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}