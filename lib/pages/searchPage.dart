// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/Category.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/providers/categoryProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/categoryDesign.dart';
import 'package:gotour/widgets/destinationItem.dart';
import 'package:gotour/widgets/postData.dart';

import 'home.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  Future<QuerySnapshot> futureDestinationResults;
  //CategoryDatabaseManager categoryDatabaseManager = CategoryDatabaseManager();
  Future<List<Category>> futureCategoryResult;
  bool loading = false;
  bool destLoading = false;
  bool locationLoading = false;
  bool deleting = false;

  @override
  void initState() {
    super.initState();

    getCategories();
  }

  getCategories() async {
    setState(() {
      loading = true;
    });

    futureCategoryResult = CategoryProvider().getCategoryList();

    setState(() {
      loading = false;
    });
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  searchLocation() {
    Future<QuerySnapshot> allDestinations = destinationsReference
        .where("searchKey",
            isGreaterThanOrEqualTo:
                searchTextEditingController.text.trim().toLowerCase())
        //.orderBy("city", descending: false)
        .limit(3)
        .get();

    setState(() {
      futureDestinationResults = allDestinations;
    });
  }

  searchDestination() {
    Future<QuerySnapshot> allPlaces = postsReference
        .where("searchKey",
            isGreaterThanOrEqualTo:
                searchTextEditingController.text.trim().toLowerCase())
        //.orderBy("name", descending: true)
        .limit(3)
        .get();

    setState(() {
      futureSearchResults = allPlaces;
    });
  }

  deletePost(String postId) async {
    setState(() {
      deleting = true;
    });

    // await storageReference.child(postId).delete();
    //
    // await postsReference.document(postId).delete();

    Fluttertoast.showToast(msg: "Navigate to your profile to delete data");

    setState(() {
      deleting = false;
    });
  }

  onChange(String string) {
    setState(() {
      searchTextEditingController.text = string;
    });
  }

  showOptions(mContext, String postName, String postId) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Edit $postName",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Delete Post"),
                onPressed: () => deletePost(postId)),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  displayPlacesFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Text("");
        } else {
          List<PostData> postList = [];

          dataSnapshot.data.documents.forEach((document) {
            Post post = Post.fromDocument(document);
            PostData postData = PostData(
              post: post,
              onPressed: () => showOptions(context, post.name, post.postId),
            );
            postList.add(postData);
          });

          if (postList.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  "No Posts related to ${searchTextEditingController.text}"),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Results for ${searchTextEditingController.text}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Divider(),
                deleting
                    ? circularProgress()
                    : Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          children: postList,
                        ),
                      ),
              ],
            );
          }
        }
      },
    );
  }

  destinationsFoundScreen() {
    return FutureBuilder(
      future: futureDestinationResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Text("");
        } else {
          List<DestinationItem> destinationsResult = [];
          dataSnapshot.data.documents.forEach((document) {
            Destination destination = Destination.fromDocument(document);
            DestinationItem destinationFound = DestinationItem(
              destination: destination,
            );
            destinationsResult.add(destinationFound);
          });

          if (destinationsResult.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  "No destinations related to ${searchTextEditingController.text}"),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Destinations",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Divider(),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    children: destinationsResult,
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  displayCategories() {
    return FutureBuilder(
      future: futureCategoryResult,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          List<Category> categories = snapshot.data;

          return Container(
            child: GridView.count(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(categories.length, (index) {
                Category category = categories[index];

                return CategoryDesign(
                  category: category,
                );
              }),
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              title: Text(
                "Search",
                style: TextStyle(color: Colors.teal),
              ),
              //floating: true,
              //elevation: 0.0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: isBright ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: EdgeInsets.only(left: size.width * 0.01 //20.0
                          ),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " Looking For \n Something?",
                            style: GoogleFonts.fredokaOne(
                                fontSize: size.width * 0.08 //35.0,
                                ),
                          )),
                    )),
              ),
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width,
                    70.0 //size.height * 0.01//70.0
                    ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchTextEditingController,
                    cursorColor: Theme.of(context).primaryColor,
                    onFieldSubmitted: onChange,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            width: 1.0,
                          )),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isBright ? Colors.black : Colors.white,
                        ),
                        onPressed: emptyTheTextFormField,
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Type here...",
                      labelText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: searchTextEditingController.text.isEmpty
              ? displayCategories()
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: searchDestination,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: Colors.teal, width: 2.0)),
                            child: Center(
                              child: Text(
                                "See Travel Destinations",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: searchLocation,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(color: Colors.teal, width: 2.0)),
                            child: Center(
                              child: Text(
                                "See Locations",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      displayPlacesFoundScreen(),
                      destinationsFoundScreen()
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
