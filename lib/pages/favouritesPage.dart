// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/postData.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  // final PostDataBaseManager _postDataBaseManager = PostDataBaseManager();
  // Future futureFavourites;

  // @override
  // void initState() {
  //   futureFavourites = _postDataBaseManager.getFavourites();
  //
  //   super.initState();
  // }
  //
  // currentUserFavourites() {
  //   return FutureBuilder(
  //     future: futureFavourites,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return circularProgress();
  //       } else {
  //         List<Post> favouriteList = snapshot.data;
  //
  //         if (favouriteList.isEmpty) {
  //           return Container(
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: const <Widget>[
  //                   Image(
  //                     image: AssetImage("assets/images/nodata.png"),
  //                     height: 100.0,
  //                     width: 100.0,
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.only(top: 10.0),
  //                     child: Text(
  //                       "No Favourites",
  //                       style: TextStyle(
  //                           color: Colors.grey,
  //                           fontSize: 20.0,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         } else {
  //           return ListView.builder(
  //             physics: const BouncingScrollPhysics(),
  //             shrinkWrap: true,
  //             itemCount: favouriteList.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               Post post = favouriteList[index];
  //
  //               return PostData(
  //                 post: post,
  //                 onPressed: () => showOptions(context, post.name, post.postId),
  //               );
  //             },
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  deletePost(String postId) async {}

  showOptions(mContext, String postName, String postId) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Edit $postName",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text("Delete Post"),
                onPressed: () => deletePost(postId)),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "My Favourites",
          style: GoogleFonts.fredokaOne(color: Colors.teal),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container() //currentUserFavourites(),
    );
  }
}
