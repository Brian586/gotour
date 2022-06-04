// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/hotel_carousel.dart';

import 'models/suggestionModel.dart';

class SuggestionList extends StatefulWidget {
  @override
  _SuggestionListState createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  bool loading = false;
  bool loadingOld = false;
  //List<Suggestion> suggestionList = [];
  Future futureSuggestions;
  SuggestionDBManager suggestionDBManager = SuggestionDBManager();

  @override
  void initState() {
    super.initState();

    fetchAllSuggestions();
  }

  Future<void> fetchAllSuggestions() async {
    setState(() {
      loading = true;
    });

    //QuerySnapshot querySnapshot = await Firestore.instance.collection("suggestions").orderBy("timestamp", descending: true).getDocuments();

    var timestamp = await suggestionDBManager.getTimestamp("DESC");

    if (timestamp == 0) {
      await FirebaseFirestore.instance
          .collection("suggestions")
          .where("timestamp", isLessThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) async {
          Suggestion suggestion = Suggestion.fromDocument(document);

          await suggestionDBManager.insertSuggestion(suggestion);
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection("suggestions")
          .where("timestamp", isGreaterThan: timestamp)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) async {
          Suggestion suggestion = Suggestion.fromDocument(document);

          await suggestionDBManager.insertSuggestion(suggestion);
        });
      });
    }

    setState(() {
      loading = false;
      futureSuggestions = suggestionDBManager.getSuggestions();
    });
  }

  loadOldFeedPosts() async {
    setState(() {
      loadingOld = true;
    });

    var timestamp = await suggestionDBManager.getTimestamp("ASC");

    await FirebaseFirestore.instance
        .collection("suggestions")
        .where("timestamp", isLessThan: timestamp)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Suggestion suggestion = Suggestion.fromDocument(document);

        await suggestionDBManager.insertSuggestion(suggestion);
      });
    });

    setState(() {
      loadingOld = false;
      futureSuggestions = suggestionDBManager.getSuggestions();
    });
  }

  displayStuff() {
    return FutureBuilder(
      future: futureSuggestions,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          List<Suggestion> suggestions = snapshot.data;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                  itemCount: suggestions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Suggestion suggestion = suggestions[index];

                    return ListTile(
                      title: Text(
                        suggestion.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        suggestion.suggestion == null
                            ? "no data"
                            : suggestion.suggestion,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        HotelCarousel()
                            .createState()
                            .readTimestamp(suggestion.timestamp),
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                loadingOld
                    ? Text("")
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RaisedButton.icon(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            elevation: 6.0,
                            onPressed: loadOldFeedPosts,
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                            ),
                            label: Text(
                              "Load More",
                              style: GoogleFonts.fredokaOne(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Suggestions",
          style: GoogleFonts.fredokaOne(color: Colors.teal),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? circularProgress()
          : RefreshIndicator(
              child: displayStuff(), onRefresh: fetchAllSuggestions),
    );
  }
}
