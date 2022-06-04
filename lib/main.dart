import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:gotour/pages/destinationPage.dart';
import 'package:gotour/pages/feedUpload.dart';
import 'package:gotour/pages/home.dart';
import 'package:gotour/pages/sharedFilesPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gotour/providers/carouselProvider.dart';
import 'package:gotour/providers/categoryProvider.dart';
import 'package:gotour/providers/destinationProvider.dart';
import 'package:gotour/providers/feedProvider.dart';
import 'package:gotour/providers/load_provider.dart';
import 'package:gotour/providers/localityProvider.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'Auth/login.dart';
import 'Config/config.dart';
import 'lifeCycleManager.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initialization: initFuture);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CarouselProvider>(
          create: (_) => CarouselProvider()),
      ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider()),
      ChangeNotifierProvider<DestinationProvider>(
          create: (_) => DestinationProvider()),
      ChangeNotifierProvider<FeedProvider>(create: (_) => FeedProvider()),
      ChangeNotifierProvider<LocalityProvider>(
          create: (_) => LocalityProvider()),
      ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
      ChangeNotifierProvider<LoadProvider>(create: (_) => LoadProvider()),
      ChangeNotifierProvider<CategoryType>(create: (_) => CategoryType()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (brightness) => ThemeData(
              primarySwatch: Colors.teal,
              brightness: brightness,
            ),
            themedWidgetBuilder: (context, theme) {
              return MaterialApp(
                title: 'Gotour',
                debugShowCheckedModeBanner: false,
                theme: theme,
                home: SplashScreen(),
              );
            },
          );
        }

        return circularProgress();
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Account currentUser;
  // StreamSubscription _intentDataStreamSubscription;
  // List<SharedMediaFile> _sharedFiles = [];

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription =
    //     ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
    //       setState(() {
    //         print("Shared:" + (_sharedFiles?.map((f)=> f.path)?.join(",") ?? ""));
    //         _sharedFiles = value;
    //         // _picturePath = value[0].path;
    //         // pictureFile = File(_picturePath);
    //       });
    //     }, onError: (err) {
    //       print("getIntentDataStream error: $err");
    //     });

    // // For sharing images coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
    //   //bool isVideo = value[0].type == SharedMediaType.VIDEO;

    //   setState(() {
    //     _sharedFiles = value;
    //     // _picturePath = value[0].path;
    //     // pictureFile = File(_picturePath);
    //   });
    // });

    displaySplash();
  }

  // @override
  // void dispose() {
  //   _intentDataStreamSubscription.cancel();
  //   super.dispose();
  // }

  // displayDialog(mContext) {
  //   bool isMe = (currentUser.id == brian.id);

  //   return showDialog(
  //     barrierDismissible: false,
  //     context: mContext,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: Text("New Post",textAlign: TextAlign.center, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //             child: Text("Post as Feed",),
  //             onPressed: () async {
  //               await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                   FeedUpload(sharedFiles: _sharedFiles)));

  //               Navigator.pop(context);
  //             },
  //           ),
  //           SimpleDialogOption(
  //             child: Text("Post as Destination/Hotel etc",),
  //             onPressed: () async {
  //               await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                   SharedFilesPage(sharedFiles: _sharedFiles)));

  //               Navigator.pop(context);
  //             },
  //           ),
  //           isMe ?
  //             SimpleDialogOption(
  //               child: Text("Carousel Images",),
  //               onPressed: () async {
  //                 await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                     UploadCarousel(sharedFiles: _sharedFiles)));

  //                 Navigator.pop(context);
  //               },
  //             ) : Container(),
  //             isMe ? SimpleDialogOption(
  //               child: Text("New Destination",),
  //               onPressed: () async {
  //                 await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                     UploadDestinations(sharedFiles: _sharedFiles)));

  //                 Navigator.pop(context);
  //               },
  //             ) : Container(),
  //             isMe ? SimpleDialogOption(
  //               child: Text("New Landmark",),
  //               onPressed: () async {
  //                 await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                     UploadLandmark(sharedFiles: _sharedFiles)));

  //                 Navigator.pop(context);
  //               },
  //             ): Container(),
  //             isMe ? SimpleDialogOption(
  //               child: Text("New Locality",),
  //               onPressed: () async {
  //                 await Navigator.push(context,  MaterialPageRoute(builder: (_) =>
  //                     UploadLocality(sharedFiles: _sharedFiles)));

  //                 Navigator.pop(context);
  //               },
  //             ) : Container(),
  //           SimpleDialogOption(
  //             child: Text("Cancel",),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  displaySplash() {
    Timer(const Duration(seconds: 3), () async {
      auth.authStateChanges().listen((User user) async {
        if (user != null) {
          var user = auth.currentUser;

          await usersReference.doc(user.uid).get().then((dataSnapshot) {
            setState(() {
              GoTour.account = Account.fromDocument(dataSnapshot);
            });
          });

          Route route = MaterialPageRoute(builder: (_) => HomePage());
          Navigator.pushReplacement(context, route);
        } else {
          Route route = MaterialPageRoute(builder: (_) => HomePage());
          Navigator.pushReplacement(context, route);
          // Route route = MaterialPageRoute(builder: (_) => Login());
          // Navigator.pushReplacement(context, route);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    TextStyle style = const TextStyle(fontWeight: FontWeight.w800);

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        bool isDesktop = sizeInfo.isDesktop;

        return Material(
            child: Container(
          height: screenHeight,
          width: width,
          decoration: BoxDecoration(
            color:
                isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "assets/images/testlogo2.png",
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    //width: 60.0, height: 35.0,
                    // height: 80.0,
                    // width: 80.0,
                    height: screenHeight * 0.15,
                    width: screenHeight * 0.15,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/testlogo2.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Gotour",
                  style: GoogleFonts.fredokaOne(
                      fontSize: isDesktop ? width * 0.03 : width * 0.05, //20.0,
                      color: Colors.teal.shade800),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Explore ",
                      style: style,
                    ),
                    const Icon(
                      Icons.circle,
                      size: 5.0,
                    ),
                    Text(
                      " Discover ",
                      style: style,
                    ),
                    const Icon(
                      Icons.circle,
                      size: 5.0,
                    ),
                    Text(
                      " Connect",
                      style: style,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
