// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Auth/register.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/widgets/ProgressWidget.dart';

import 'home.dart';

class EditLocation extends StatefulWidget {
  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  Future<QuerySnapshot> futureDestinationResults;
  bool isVisible = true;
  String _id = "";

  searchLibrary(String cityName) async {
    setState(() {
      isVisible = false;
    });

    Future<QuerySnapshot> allDestinations = destinationsReference
        .where(
          "searchKey",
          isGreaterThanOrEqualTo: cityName.toLowerCase(),
        )
        //.orderBy("city", descending: false)
        .limit(5)
        .get();

    setState(() {
      isVisible = true;
      futureDestinationResults = allDestinations;
    });
  }

  saveLocationAndExit() {
    if (city.text.isNotEmpty && country.text.isNotEmpty) {
      String locationInfo = "${city.text.trim()},${country.text.trim()}";
      // locationInfo = {
      //   "city": city.text.trim(),
      //   "country": country.text.trim()
      // };

      Navigator.pop(context, locationInfo);
    } else {
      Fluttertoast.showToast(msg: "Write Location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Edit Location",
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context, "");
            }),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              CustomTextField(
                controller: city,
                data: Icons.add_location_alt_outlined,
                hintText: "City/Town",
                isObscure: false,
              ),
              CustomTextField(
                controller: country,
                data: Icons.airplanemode_active,
                hintText: "Country",
                isObscure: false,
              ),
              SizedBox(
                height: 20.0,
              ),
              isVisible
                  ? FlatButton.icon(
                      splashColor: Colors.teal,
                      icon: Icon(
                        Icons.search,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        city.text.isNotEmpty
                            ? searchLibrary(city.text.toLowerCase().trim())
                            : Fluttertoast.showToast(msg: "Write City name");
                      },
                      label: Text(
                        "Search from our Library",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.040,
                          color: Colors.teal,
                        ),
                      ),
                    )
                  : Text(""),
              futureDestinationResults != null
                  ? FutureBuilder(
                      future: futureDestinationResults,
                      builder: (context, dataSnapshot) {
                        if (!dataSnapshot.hasData) {
                          return circularProgress();
                        } else {
                          List<NewLocation> newLocations = [];
                          dataSnapshot.data.documents.forEach((document) {
                            Destination destination =
                                Destination.fromDocument(document);
                            NewLocation newLocation = NewLocation(
                              destination: destination,
                              id: _id,
                              onTap: () {
                                setState(() {
                                  city.text = destination.city;
                                  country.text = destination.country;
                                  _id = destination.destinationId;
                                });
                              },
                            );
                            newLocations.add(newLocation);
                          });

                          if (newLocations.length == 0) {
                            setState(() {
                              isVisible = true;
                            });

                            return Text("");
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: newLocations,
                            );
                          }
                        }
                      },
                    )
                  : Text(""),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.fredokaOne(
                          color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.teal,
                    onPressed: saveLocationAndExit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewLocation extends StatelessWidget {
  final Destination destination;
  final Function onTap;
  final String id;

  NewLocation({this.destination, this.onTap, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: id == destination.destinationId
          ? Colors.teal.withOpacity(0.2)
          : Colors.transparent,
      trailing: id == destination.destinationId
          ? Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.teal,
            )
          : Text(""),
      onTap: onTap,
      leading: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(destination.imageUrl),
          fit: BoxFit.cover,
        )),
      ),
      title: Text(
        destination.city,
        style: GoogleFonts.fredokaOne(),
      ),
      subtitle: Text(
        destination.country,
      ),
    );
  }
}
