// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/admin/suggestionList.dart';
import 'UploadCarousel.dart';
import 'UploadDestinations.dart';
import 'UploadLandmark.dart';
import 'UploadLocalities.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Admin",
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Option(
                route: MaterialPageRoute(
                    builder: (context) => const UploadDestinations()),
                title: "Upload Destinations",
                subTitle: "Add incredible places",
                icon: const Icon(
                  Icons.edit_location_outlined,
                  color: Colors.grey,
                ),
              ),
              Option(
                route: MaterialPageRoute(
                    builder: (context) => const UploadLocality()),
                title: "Upload Localities",
                subTitle: "Add subPlaces",
                icon: const Icon(
                  Icons.edit_location_outlined,
                  color: Colors.grey,
                ),
              ),
              Option(
                route: MaterialPageRoute(
                    builder: (context) => const UploadCarousel()),
                title: "Upload Carousels",
                subTitle: "Add beautiful images to app",
                icon: const Icon(
                  Icons.photo_sharp,
                  color: Colors.grey,
                ),
              ),
              Option(
                route: MaterialPageRoute(
                    builder: (context) => const UploadLandmark()),
                title: "Upload Landmarks",
                subTitle: "Make places recorgnizable",
                icon: const Icon(
                  Icons.photo_sharp,
                  color: Colors.grey,
                ),
              ),
              const Divider(
                height: 20.0,
                thickness: 3.0,
              ),
              Option(
                route:
                    MaterialPageRoute(builder: (context) => SuggestionList()),
                title: "Suggestions",
                subTitle: "See what people suggest",
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String title;
  final String subTitle;
  final Route route;
  final Icon icon;

  const Option({Key key, this.route, this.title, this.subTitle, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(subTitle),
      onTap: () {
        Route page = route;
        Navigator.push(context, page);
      },
    );
  }
}
