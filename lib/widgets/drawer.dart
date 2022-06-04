import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/admin/adminHome.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/about.dart';
import 'package:gotour/pages/categories.dart';
import 'package:gotour/pages/favouritesPage.dart';
import 'package:gotour/pages/feedUpload.dart';
import 'package:gotour/pages/profilePage.dart';
import 'package:gotour/pages/searchPage.dart';
import 'package:gotour/pages/settings.dart';
import 'package:gotour/pages/suggestionsPage.dart';
import 'package:gotour/pages/uploadPage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  openApp() {
    Share.share(
      "https://gotourapp.page.link/install",
    );
  }

  displayLogo(double width) {
    return Center(
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
              height: width * 0.05,
              width: width * 0.05,
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
                //fontSize: isDesktop ? width * 0.03 : width * 0.05, //20.0,
                color: Colors.teal.shade800),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Explore ",
                //style: style,
              ),
              Icon(
                Icons.circle,
                size: 5.0,
              ),
              Text(
                " Discover ",
                //style: style,
              ),
              Icon(
                Icons.circle,
                size: 5.0,
              ),
              Text(
                " Connect",
                //style: style,
              ),
            ],
          )
        ],
      ),
    );
  }

  displayUserInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundImage: const AssetImage(
              "assets/images/profile.png"), //NetworkImage(widget.feed.ownerUrl),
          backgroundColor: Colors.teal.shade100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              // child: CachedNetworkImage(
              //   imageUrl: GoTour.account.url,
              //   height: 80.0,
              //   width: 80.0,
              //   fit: BoxFit.cover,
              //   progressIndicatorBuilder: (context, url, downloadProgress) =>
              //       Container(),
              //   errorWidget: (context, url, error) => Icon(
              //     Icons.error_outline_rounded,
              //     color: Colors.grey,
              //   ),
              // ),
              child: Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(GoTour.account.url),
                  fit: BoxFit.cover,
                )),
              )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          GoTour.account.username,
          style: GoogleFonts.fredokaOne(
            fontSize: 15.0,
          ),
        ),
        Text(
          GoTour.account.email.trimRight(),
          style: TextStyle(
            fontSize: 12.0,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isAdmin = GoTour.account.role == "Seller";
    var instagramUrl = 'https://www.instagram.com/gotour_app/';
    var twitterUrl = "https://twitter.com/GotourK";
    var facebookUrl = "https://facebook.com/";

    return Drawer(
      child: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          TextStyle style = sizeInfo.isDesktop
              ? Theme.of(context).textTheme.button
              : GoogleFonts.fredokaOne();

          return ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                //child: displayUserInfo(),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/back2.jpg"),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                        height: 65.0,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.9)
                            // gradient: LinearGradient(
                            //     colors: [Colors.black87, Colors.transparent],
                            //     begin: Alignment.bottomCenter,
                            //     end: Alignment.topCenter
                            // )
                            ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: sizeInfo.isDesktop
                          ? displayLogo(width)
                          : displayUserInfo(),
                    )
                    // Positioned(
                    //   bottom: 50.0,
                    //   left: 10.0,
                    //   child: CircleAvatar(
                    //     radius: 40.0,
                    //     backgroundColor: Colors.transparent,
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(40.0),
                    //       child: FadeInImage.assetNetwork(
                    //         placeholder: "assets/images/profile.png",
                    //         image: gCurrentUser.url,
                    //         width: 80.0,
                    //         height: 80.0,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 10.0,
                    //   left: 15.0,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(gCurrentUser.username, style: GoogleFonts.fredokaOne(fontSize: 15.0, color: Colors.white),),
                    //       Text(gCurrentUser.email.trimRight(), style: TextStyle(fontSize: 12.0, color: Colors.white),)
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              //Divider(),
              ListTile(
                leading: const Icon(
                  Icons.category_outlined,
                  color: Colors.teal,
                ),
                title: Text(
                  "Browse Categories",
                  style: style,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CategoryList()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.search,
                  color: Colors.teal,
                ),
                title: Text(
                  "Search",
                  style: style,
                ),
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => SearchPage());

                  Navigator.push(context, route);
                },
              ),
              isAdmin
                  ? ListTile(
                      leading: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.teal,
                      ),
                      subtitle: const Text("Hotels, rental houses etc."),
                      title: Text(
                        "Upload Destination",
                        style: style,
                      ),
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => const UploadPage(
                                  isFirstTime: false,
                                ));

                        Navigator.push(context, route);
                      },
                    )
                  : Container(),
              isAdmin
                  ? ListTile(
                      leading: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.teal,
                      ),
                      subtitle: const Text("Will appear on home screen"),
                      title: Text(
                        "Upload Feed Post",
                        style: style,
                      ),
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => const FeedUpload());

                        Navigator.push(context, route);
                      },
                    )
                  : Container(),
              ListTile(
                leading: const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.teal,
                ),
                title: Text(
                  "Favourites",
                  style: style,
                ),
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => FavouritesPage());

                  Navigator.push(context, route);
                },
              ),
              isAdmin
                  ? ListTile(
                      leading: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.teal,
                      ),
                      title: Text(
                        "Profile",
                        style: style,
                      ),
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  userId: GoTour.account.id,
                                ));
                        Navigator.push(context, route);
                      },
                    )
                  : Container(),
              ListTile(
                leading: const Icon(
                  Icons.subject_rounded,
                  color: Colors.teal,
                ),
                title: Text(
                  "Suggestions",
                  style: style,
                ),
                //onTap: () => showOptions(context),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuggestionsPage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: Colors.teal,
                ),
                title: Text(
                  "Share",
                  style: style,
                ),
                //onTap: () => showOptions(context),
                onTap: openApp,
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.teal,
                ),
                title: Text(
                  "Logout",
                  style: style,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((c) {
                    Route route =
                        MaterialPageRoute(builder: (context) => SplashScreen());
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.teal,
                ),
                title: Text(
                  "Settings",
                  style: style,
                ),
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => Settings());
                  Navigator.push(context, route);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.teal,
                ),
                title: Text(
                  "About",
                  style: style,
                ),
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => AboutPage());
                  Navigator.push(context, route);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Follow Us",
                  style: style.apply(
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(facebookUrl)) {
                        await launch(
                          facebookUrl,
                          universalLinksOnly: true,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error opening: $facebookUrl");
                        //throw 'There was a problem to open the url: $twitterUrl';
                      }
                    },
                    child: Container(
                      height: height * 0.04,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 1.0, color: Colors.teal)),
                      child: Center(
                          child: Text(
                        "f",
                        style: GoogleFonts.fredokaOne(
                            color: Colors.blue, fontSize: width * 0.06),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(twitterUrl)) {
                        await launch(
                          twitterUrl,
                          universalLinksOnly: true,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error opening: $twitterUrl");
                        //throw 'There was a problem to open the url: $twitterUrl';
                      }
                    },
                    child: Container(
                      height: height * 0.04,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 1.0, color: Colors.teal)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          "assets/images/twitter.png",
                          width: 10.0,
                          height: 10.0,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(instagramUrl)) {
                        await launch(
                          instagramUrl,
                          universalLinksOnly: true,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error opening: $instagramUrl");
                        //throw 'There was a problem to open the url: $instagramUrl';
                      }
                    },
                    child: Container(
                      height: height * 0.04,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 1.0, color: Colors.teal)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          "assets/images/instagram.png",
                          width: 10.0,
                          height: 10.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),

              GoTour.account.id == brian.id
                  ? ListTile(
                      leading: const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.teal,
                      ),
                      title: Text(
                        "Admin",
                        style: style,
                      ),
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => AdminHome());
                        Navigator.push(context, route);
                      },
                    )
                  : const Text(""),
            ],
          );
        },
      ),
    );
  }
}
