// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Auth/register.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/DialogBox/errorDialog.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  TextEditingController suggestion = TextEditingController();
  bool loading = false;
  String postId = Uuid().v4();

  sendSuggestion() async {
    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance.collection("suggestions").doc(postId).set({
      "suggestion": suggestion.text,
      "username": GoTour.account.username,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      Fluttertoast.showToast(msg: "Sent Successfully!");
    });

    suggestion.clear();

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Suggestions",
          style: GoogleFonts.fredokaOne(color: Colors.teal),
        ),
      ),
      body: loading
          ? circularProgress()
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Hi ${GoTour.account.username}, \nSuggest new places for us to explore!",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fredokaOne(
                          //fontSize: MediaQuery.of(context).size.width * 0.07
                          ),
                    ),
                  ),
                  //SizedBox(height: 30.0,),
                  CustomTextField(
                    controller: suggestion,
                    data: Icons.add_location_alt_outlined,
                    hintText: "Suggest a place",
                    isObscure: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    //height: 50.0,
                    //width: 120.0,
                    child: RaisedButton(
                      onPressed: () {
                        suggestion.text.isNotEmpty
                            ? sendSuggestion()
                            : showDialog(
                                context: context,
                                builder: (c) {
                                  return const ErrorAlertDialog(
                                    message: "Please write your suggestion",
                                  );
                                });
                      },
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text(
                        "Send",
                        style: GoogleFonts.fredokaOne(
                          color: Colors.white,
                        ),
                      ),
                      elevation: 5.0,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
