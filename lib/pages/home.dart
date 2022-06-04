import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/destinationPage.dart';
import 'package:gotour/pages/detailsPage.dart';
import 'package:gotour/pages/feedDetails.dart';
import 'package:gotour/pages/timelinePage.dart';
import 'package:url_launcher/url_launcher.dart';

final usersReference = FirebaseFirestore.instance.collection("users");
final postsReference = FirebaseFirestore.instance.collection("posts");
final feedReference = FirebaseFirestore.instance.collection("feed");
final localityReference = FirebaseFirestore.instance.collection("localities");
final destinationsReference =
    FirebaseFirestore.instance.collection("destinations");
final storageReference = FirebaseStorage.instance.ref().child("Post Pictures");
final feedStorageReference = FirebaseStorage.instance.ref().child("Feed");
final profilePhotoReference =
    FirebaseStorage.instance.ref().child("Profile Photos");
final carouselStorageReference =
    FirebaseStorage.instance.ref().child("Carousel Pictures");
final carouselReference = FirebaseFirestore.instance.collection("carousel");

final DateTime timestamp = DateTime.now();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int currentVersion = 0;
  bool loading = false;
  int documentCount = 1;

  @override
  void initState() {
    super.initState();

    //this.initDynamicLinks();

    checkDeviceToken();
  }

  checkDeviceToken() async {
    //Get Device Token

    await messaging
        .getToken(
      vapidKey: GoTour.vapidKey,
    )
        .then((deviceToken) async {
      //print(deviceToken);

      await FirebaseFirestore.instance
          .collection("tokens")
          .doc("tokenList_" + documentCount.toString())
          .get()
          .then((querySnapshot) async {
        List<dynamic> tokens = [];

        //print(querySnapshot.data());

        setState(() {
          tokens = querySnapshot.get("tokens");
        });

        if (!tokens.contains(deviceToken)) {
          print("Device Token is Absent");
          tokens.add(deviceToken);

          await FirebaseFirestore.instance
              .collection("tokens")
              .doc("tokenList_" + documentCount.toString())
              .set({
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "count": tokens.length,
            "tokens": tokens,
          });

          await usersReference.doc(GoTour.account.id).get().then((value) async {
            List<dynamic> userTokens = value.get("deviceTokens");

            userTokens.add(deviceToken);

            await value.reference.set({
              "deviceTokens": userTokens,
            }, SetOptions(merge: true));
          });
        } else {
          print("Device Token is Present");
        }
      });
    });

    //Check if it is in Firestore

    //Add if it is not
  }

  handleRouting(Uri deepLink) async {
    //print(deepLink.pathSegments);
    //Fluttertoast.showToast(msg: deepLink.pathSegments.last);

    if (deepLink.pathSegments.contains("destinations")) {
      await destinationsReference
          .doc(deepLink.pathSegments.last)
          .get()
          .then((value) async {
        if (value.exists) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DestinationPage(
                        destination: Destination.fromDocument(value),
                      )));
        }
      });
    } else if (deepLink.pathSegments.contains("posts")) {
      await postsReference
          .doc(deepLink.pathSegments.last)
          .get()
          .then((value) async {
        if (value.exists) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPage(
                        post: Post.fromDocument(value),
                      )));
        }
      });
    } else if (deepLink.pathSegments.contains("feed")) {
      await feedReference
          .doc(deepLink.pathSegments.last)
          .get()
          .then((value) async {
        if (value.exists) {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FeedDetails(
                        feed: Feed.fromDocument(value),
                      )));
        }
      });
    }
  }

  Future<void> initDynamicLinks() async {
    setState(() {
      loading = true;
    });
    //When app is in the Background

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        //TODO: Implement function here
        //Navigator.pushNamed(context, deepLink.path);

        await handleRouting(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    //When app is not opened

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      //TODO: Implement function here
      //Navigator.pushNamed(context, deepLink.path);
      await handleRouting(deepLink);
    }

    setState(() {
      loading = false;
    });
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  // checkUpdate() async {
  //   await FirebaseFirestore.instance
  //       .collection("versions")
  //       //.doc(AppConfig.account.userID).collection("versions")
  //       .orderBy("timestamp", descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((document) {
  //       if (document["timestamp"] > currentVersion) {
  //         showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) => AlertDialog(
  //             titlePadding: EdgeInsets.zero,
  //             title: ListTile(
  //               leading: Image.asset(
  //                 "assets/images/testlogo2.png",
  //                 height: 80.0,
  //                 width: 80.0,
  //                 fit: BoxFit.contain,
  //               ),
  //               title: Text("Gotour needs an update"),
  //               subtitle: Text("Download size: 29 MB"),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 const Text('To use this app, download the latest version'),
  //                 SizedBox(
  //                   height: 10.0,
  //                 ),
  //                 Image.asset(
  //                   "assets/images/google_play_logo.png",
  //                   height: 40.0,
  //                   width: 200.0,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('Later'),
  //               ),
  //               Container(
  //                 width: 150.0,
  //                 child: RaisedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     _launchURL(
  //                         "https://play.google.com/store/apps/details?id=com.brian586.gotour_kenya");
  //                   },
  //                   color: Colors.teal.shade700,
  //                   child: Center(
  //                     child: Text(
  //                       "Update",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return loading ? const Scaffold() : const TimelinePage();
  }
}
