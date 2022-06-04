// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Landmark {
  final String name;
  final String city;
  final String locality;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final int timestamp;

  Landmark({
    this.longitude,
    this.latitude,
    this.name,
    this.locality,
    this.city,
    this.imageUrl,
    this.timestamp
  });

  factory Landmark.fromDocument(DocumentSnapshot doc) {
    return Landmark(
      name: doc["name"],
      city: doc["city"],
      locality: doc["locality"],
      latitude: doc["latitude"],
      longitude: doc["longitude"],
      imageUrl: doc["url"],
      timestamp: doc["timestamp"]
    );
  }

}