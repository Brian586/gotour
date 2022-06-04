// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/GoogleMaps.dart';
import 'package:gotour/models/Landmark.dart';
import 'package:gotour/models/Options.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/postImages.dart';
import 'package:gotour/pages/profilePage.dart';
import 'package:gotour/pages/viewImages.dart';
import 'package:gotour/shareAssistant/shareAssistant.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/customAppbar.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:gotour/widgets/otherImages.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';

import 'home.dart';

class DetailsPage extends StatefulWidget {
  final Post post;

  const DetailsPage({
    Key key,
    this.post,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  //final PostDataBaseManager _postDataBaseManager = PostDataBaseManager();
  final PostImageDBManager postImageDBManager = PostImageDBManager();
  bool imagesLoading = false;
  bool videosLoading = false;
  bool landmarksLoading = false;
  bool isLiked = false;
  Future futureImages;
  Future futureVideos;
  List<String> _listOfImages = [];
  List<String> _listOfVideos = [];
  List<Landmark> landmarks = [];
  double roundedContainerHeight = 80.0;
  bool lastStatus = true;
  // BannerAd banner;

  @override
  void initState() {
    super.initState();

    print(widget.post.postId);

    //checkFavourite();
    //checkCoordinates();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final adState = Provider.of<AdState>(context);
  //   adState.initialization.then((status) {
  //     setState(() {
  //       banner = BannerAd(
  //           size: adState.adSize,
  //           adUnitId: adState.bannerAdUnitId,
  //           listener: adState.adListener,
  //           request: adState.request
  //       )..load();
  //     });
  //   });
  // }

  // checkFavourite() async {
  //   if (await _postDataBaseManager.checkFavourite(widget.post.postId)) {
  //     setState(() {
  //       isLiked = true;
  //     });
  //   } else {
  //     setState(() {
  //       isLiked = false;
  //     });
  //   }
  // }

  // checkCoordinates() async {
  //   List<Location> locations = await locationFromAddress(
  //       "${widget.post.city}, ${widget.post.country}");
  //
  //   if (widget.post.latitude != locations[0].latitude &&
  //       widget.post.longitude != locations[0].longitude) {
  //     await postsReference.doc(widget.post.postId).update({
  //       "latitude": locations[0].latitude,
  //       "longitude": locations[0].longitude,
  //     }).then((value) async {
  //       await _postDataBaseManager.updatePost(
  //           locations[0].latitude, locations[0].longitude, widget.post.postId);
  //       Fluttertoast.showToast(msg: "Updated Coordinates");
  //     });
  //   }
  // }

  getOtherPhotos() async {
    setState(() {
      imagesLoading = true;
    });

    int count =
        await postImageDBManager.checkForImages(widget.post.postId, "image");

    if (count == 0) {
      await postsReference
          .doc(widget.post.postId)
          .collection("other images")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((document) async {
          PostImage postImage = PostImage(
              urls: document.get('urls'),
              postId: widget.post.postId,
              type: "image");

          await postImageDBManager.insertImage(postImage);

          // document.data['urls'].forEach((url) {
          //   _listOfImages.add(url);
          // });
        });
      });

      setState(() {
        futureImages =
            postImageDBManager.getImages(widget.post.postId, "image");
      });
    } else {
      setState(() {
        futureImages =
            postImageDBManager.getImages(widget.post.postId, "image");
      });
    }

    // if(_listOfImages.length == 0)
    // {
    //   Fluttertoast.showToast(msg: "No other images for this post");
    // }

    setState(() {
      imagesLoading = false;
    });
  }

  loadVideos() async {
    setState(() {
      videosLoading = true;
    });

    int count =
        await postImageDBManager.checkForImages(widget.post.postId, "video");

    if (count == 0) {
      await postsReference
          .doc(widget.post.postId)
          .collection("videos")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((document) async {
          PostImage postImage = PostImage(
            urls: document.get("urls"),
            type: "video",
            postId: widget.post.postId,
          );

          await postImageDBManager.insertImage(postImage);

          // _listOfVideos = [];
          // document.data["urls"].forEach((url) {
          //   _listOfVideos.add(url);
          // });
        });
      });

      setState(() {
        futureVideos =
            postImageDBManager.getImages(widget.post.postId, "video");
      });
    } else {
      setState(() {
        futureVideos =
            postImageDBManager.getImages(widget.post.postId, "video");
      });
    }

    // if(_listOfVideos.length == 0)
    //   {
    //     Fluttertoast.showToast(msg: "No videos for this post");
    //   }

    setState(() {
      videosLoading = false;
    });
  }

  loadLandMarks() async {
    setState(() {
      landmarksLoading = true;
    });

    await FirebaseFirestore.instance
        .collection("landmarks")
        .where("city", isEqualTo: widget.post.city)
        .where("locality", isEqualTo: widget.post.locality)
        .orderBy("timestamp")
        .limit(4)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) {
        double distanceInMeters = Geolocator.distanceBetween(
            widget.post.latitude,
            widget.post.longitude,
            document.get("latitude"),
            document.get("longitude"));
        if (distanceInMeters <= 500) {
          landmarks.add(Landmark.fromDocument(document));
        }
      });
    });

    if (landmarks.length == 0) {
      Fluttertoast.showToast(msg: "There are no Landmarks for this post");
    }

    setState(() {
      landmarksLoading = false;
    });
  }

  displayVideos() {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: futureVideos,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("");
        } else {
          _listOfVideos = snapshot.data;

          if (_listOfVideos.isEmpty) {
            Fluttertoast.showToast(msg: "No images for this post");

            return Text("");
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Videos",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.teal,
                      //fontSize:  size.width * 0.046,//18.0,
                      fontWeight: FontWeight.bold,
                      //letterSpacing: 1.3,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.22, //220.0,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _listOfVideos.length,
                    itemBuilder: (BuildContext context, int index) {
                      String url = _listOfVideos[index];

                      return VideoWidget(
                        url: url,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  displayOtherPhotos() {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: futureImages,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("");
        } else {
          _listOfImages = snapshot.data;

          if (_listOfImages.isEmpty) {
            Fluttertoast.showToast(msg: "No images for this post");

            return const Text("");
            // return Center(
            //   child: FlatButton.icon(
            //       onPressed: getOtherPhotos,
            //       icon: Icon(Icons.filter, color: Colors.teal,),
            //       label: Text("See More Images", style: GoogleFonts.fredokaOne(
            //         //fontSize: 15.0,
            //           color: Colors.teal),)
            //   ),
            // );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Photos",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.teal,
                          //fontSize: size.width * 0.046,//18.0,
                          fontWeight: FontWeight.bold,
                          //letterSpacing: 1.3,
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.grid_view),
                      //   onPressed: () {},
                      // )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: size.height * 0.2, //220.0,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _listOfImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      String url = _listOfImages[index];

                      return OtherImages(
                        url: url,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }

  Widget _buildSliverHead(Color color, BuildContext mContext) {
    Size size = MediaQuery.of(context).size;

    return SliverPersistentHeader(
      pinned: true,
      delegate: BackgroundImage(
        expandedHeight: size.height * 0.5,
        url: widget.post.imageUrl,
        roundedContainerHeight: size.height * 0.09, //roundedContainerHeight,
        post: widget.post,
        color: color,
        mContext: mContext,
        isLiked: isLiked,
        onPressed: () {
          favouriteFx();
        },
        username: widget.post.username,
        ownerUrl: widget.post.ownerUrl,
        email: widget.post.email,
      ),
    );
  }

  favouriteFx() async {
    if (isLiked) {
      setState(() {
        isLiked = false;
      });
      //await _postDataBaseManager.deleteFavourite(widget.post.postId);

      Fluttertoast.showToast(msg: "Successfully removed from Favourites");
    } else {
      setState(() {
        isLiked = true;
      });
      //await _postDataBaseManager.insertFavourite(widget.post);

      Fluttertoast.showToast(msg: "Successfully added to Favourites");
    }
  }

  handleImages() {
    return imagesLoading
        ? circularProgress()
        : futureImages == null
            ? Center(
                child: FlatButton.icon(
                    onPressed: getOtherPhotos,
                    icon: const Icon(
                      Icons.filter,
                      color: Colors.teal,
                    ),
                    label: Text(
                      "See More Images",
                      style: GoogleFonts.fredokaOne(
                          //fontSize: 15.0,
                          color: Colors.teal),
                    )),
              )
            : displayOtherPhotos();
  }

  handleVideos() {
    return videosLoading
        ? circularProgress()
        : futureVideos == null
            ? Center(
                child: FlatButton.icon(
                    onPressed: loadVideos,
                    icon: const Icon(
                      Icons.video_collection_outlined,
                      color: Colors.teal,
                    ),
                    label: Text(
                      "Videos",
                      style: GoogleFonts.fredokaOne(
                          //fontSize: 15.0,
                          color: Colors.teal),
                    )),
              )
            : displayVideos();
  }

  handleLandmarks() {
    return landmarksLoading
        ? circularProgress()
        : landmarks.isEmpty
            ? Center(
                child: FlatButton.icon(
                    onPressed: loadLandMarks,
                    icon: const Icon(
                      Icons.landscape_outlined,
                      color: Colors.teal,
                    ),
                    label: Text(
                      "See Landmarks",
                      style: GoogleFonts.fredokaOne(
                          //fontSize: 15.0,
                          color: Colors.teal),
                    )),
              )
            : displayLandmarks();
  }

  Widget _buildDetail() {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: sizeInfo.isDesktop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              widget.post.description == ""
                  ? const Text("")
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            "Description",
                            style: TextStyle(
                                color: Colors.teal,
                                //fontSize:  size.width * 0.046,//18.0,
                                //letterSpacing: 1.3,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            widget.post.description,
                            style: const TextStyle(
                                //color: Colors.black,
                                //fontSize: size.width * 0.038//15.0
                                ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20.0,
              ),
              //====================OTHER IMAGES==========================//
              sizeInfo.isDesktop ? Container() : handleImages(),
              sizeInfo.isDesktop
                  ? Container()
                  : const SizedBox(
                      height: 20.0,
                    ),
              sizeInfo.isDesktop ? Container() : handleVideos(),
              const SizedBox(
                height: 20.0,
              ),
              displayAddressInfo(size),
              //AdLayout(banner: banner),
              sizeInfo.isDesktop ? Container() : handleLandmarks(),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      },
    );
  }

  displayAddressInfo(Size size) {
    if (widget.post.address == "" && widget.post.city == "") {
      return const Text("");
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Address",
              style: TextStyle(
                  color: Colors.teal,
                  //fontSize:  size.width * 0.046,//18.0,
                  //letterSpacing: 1.3,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            widget.post.address != ""
                ? ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.teal,
                    ),
                    title: Text(
                      "${widget.post.address}, ${widget.post.locality}",
                      style: const TextStyle(
                          //color: Colors.black,
                          //fontSize: size.width * 0.038
                          ),
                    ),
                  )
                : const Text(""),
            widget.post.city != ""
                ? ListTile(
                    leading: const Icon(
                      Icons.flight,
                      color: Colors.teal,
                    ),
                    title: Text(
                      "${widget.post.city}, ${widget.post.country}",
                      style: const TextStyle(
                          //color: Colors.black,
                          //fontSize: size.width * 0.038
                          ),
                    ),
                  )
                : const Text(""),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );
    }
  }

  displayLandmarks() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) * 0.35;
    final double itemWidth = size.width / 2;

    if (landmarks.isEmpty) {
      return const Text("");
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            landmarks.length == 1 ? "Landmark" : "Landmarks",
            style: const TextStyle(
                color: Colors.teal,
                //fontSize:  size.width * 0.046,//18.0,
                //letterSpacing: 1.3,
                fontWeight: FontWeight.bold),
          ),
          GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: (itemWidth / itemHeight),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(landmarks.length, (index) {
                Landmark landmark = landmarks[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: Container(
                    height: itemHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => ViewImage(
                                      url: landmark.imageUrl,
                                      title: "",
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Hero(
                            tag: landmark.imageUrl,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0),
                              ),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/logobw.png",
                                image: landmark.imageUrl,
                                fit: BoxFit.cover,
                                height: itemHeight - 100.0,
                                width: itemWidth,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                landmark.name.trimRight(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if (sizeInfo.isDesktop) {
          return DesktopViewDetailsPage(
            post: widget.post,
            buildDetail: _buildDetail(),
          );
        }

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.grey,
                    ),
                    //iconSize: 25.0,
                    color: Colors.grey,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            // both default to 16
            // marginRight: 18,
            // marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(
                size: 22.0, color: isBright ? Colors.black : Colors.white),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor:
                isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1.0),
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.phone, color: Colors.white),
                  backgroundColor: Colors.teal,
                  label: 'Call',
                  labelStyle:
                      const TextStyle(fontSize: 18.0, color: Colors.black),
                  onTap: () => launch("tel:${widget.post.phone}")),
              SpeedDialChild(
                child: const Icon(Icons.email_outlined, color: Colors.white),
                backgroundColor: Colors.red,
                label: 'Email',
                labelStyle:
                    const TextStyle(fontSize: 18.0, color: Colors.black),
                onTap: () => launch("mailto:${widget.post.email}"),
              ),
              SpeedDialChild(
                child: const Icon(Icons.message, color: Colors.white),
                backgroundColor: Colors.green,
                label: 'SMS',
                labelStyle:
                    const TextStyle(fontSize: 18.0, color: Colors.black),
                onTap: () => launch("sms:${widget.post.phone}"),
              ),
            ],
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHead(
                  Theme.of(context).scaffoldBackgroundColor, context),
              SliverToBoxAdapter(
                child: _buildDetail(),
              )
            ],
          ),
        );
      },
    );
  }
}

class DesktopViewDetailsPage extends StatelessWidget {
  final Post post;
  final Widget buildDetail;

  const DesktopViewDetailsPage({Key key, this.post, this.buildDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: CustomDrawer(),
          ),
          const VerticalDivider(
            color: Colors.grey,
            width: 0.5,
          ),
          Expanded(
            flex: 8,
            child: Scaffold(
                appBar: PreferredSize(
                  child: const CustomAppBar(
                    showArrow: true,
                  ),
                  preferredSize: Size(size.width, size.height * 0.07),
                ),
                body: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: size.height * 0.5,
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(post.imageUrl),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                post.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  //color: Colors.white,
                                  //fontSize: size.width * 0.047,//20.0,
                                  fontWeight: FontWeight.w600,
                                  //letterSpacing: 1.2,
                                ),
                              ),
                              subtitle: Text(
                                "${post.currency} ${post.price} ${post.payPeriod}",
                                style: const TextStyle(
                                    // color: Colors.white70,
                                    //fontSize: size.width * 0.038,//15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  post.userId == GoTour.account.id
                                      ? Container()
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.favorite_border_rounded,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {},
                                        ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share_rounded,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {},
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.grey,
                                    ),
                                    offset: const Offset(0.0, 0.0),
                                    onSelected: BackgroundImage().choiceAction,
                                    itemBuilder: (BuildContext context) {
                                      return Option.options
                                          .map((String choice) {
                                        bool isName = choice == Option.name;

                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: ListTile(
                                            leading: isName
                                                ? const Icon(
                                                    Icons.notes_rounded,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.red,
                                                  ),
                                            title: Text(
                                              choice,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: isName
                                                ? const Text("Search by name")
                                                : const Text(
                                                    "Search by Coordinates"),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              userId: post.userId,
                                            )));
                              },
                              leading: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(post.ownerUrl),
                              ),
                              title: Text(
                                post.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  //fontSize: size.width * 0.04
                                ),
                              ),
                              subtitle: Text(
                                "Posted " +
                                    BackgroundImage()
                                        .readTimestamp(post.timestamp) +
                                    " ago", //email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                  //fontSize: size.width * 0.04
                                ),
                              ),
                            ),
                            buildDetail
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String url;
  final double roundedContainerHeight;
  final Post post;
  final Color color;
  final BuildContext mContext;
  final String username;
  final String email;
  final String ownerUrl;
  final bool isLiked;
  final Function onPressed;

  BackgroundImage(
      {this.expandedHeight,
      this.isLiked,
      this.url,
      this.roundedContainerHeight,
      this.post,
      this.color,
      this.mContext,
      this.email,
      this.ownerUrl,
      this.username,
      this.onPressed});

  double containerTop(double shrinkOffset, Size size) {
    if (expandedHeight - roundedContainerHeight - (shrinkOffset - 2.0) <=
        minExtent - (size.height * 0.09)) //80.0
    {
      return (MediaQuery.of(mContext).size.height * 0.3) -
          roundedContainerHeight;
    } else {
      return (expandedHeight - roundedContainerHeight - (shrinkOffset - 2.0));
    }
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    //var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0) {
      //time = format.format(date);
      time = 'now';
    } else if (diff.inSeconds > 0 && diff.inMinutes == 0) {
      time = diff.inSeconds.toString() + ' s';
    } else if (diff.inMinutes > 0 && diff.inHours == 0) {
      time = diff.inMinutes.toString() + ' min';
    } else if (diff.inHours > 0 && diff.inDays == 0) {
      time = diff.inHours.toString() + ' hr';
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays < 2) {
        time = diff.inDays.toString() + ' day';
      } else {
        time = diff.inDays.toString() + ' days';
      }
    } else {
      if (diff.inDays < 14) {
        time = (diff.inDays / 7).floor().toString() + ' week';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks';
      }
    }

    return time;
  }

  void choiceAction(String choice) {
    if (choice == Option.coordinates) {
      MapUtils.openMap(post.latitude, post.longitude);
    } else {
      MapUtils.searchByName(post.name, post.city, post.country);
    }
  }

  sharePost() async {
    String param = "posts/${post.postId}";

    await ShareAssistant.createAndShareUrl(
      urlParam: param,
      title: post.name,
      description: post.description,
      imageUrl: post.imageUrl,
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size size = MediaQuery.of(context).size;
    bool isPostOwner = GoTour.account.id == post.userId;

    return Stack(
      children: [
        Hero(
          tag: url,
          child: Container(
            height: expandedHeight,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).scaffoldBackgroundColor,
            // child: CachedNetworkImage(
            //   imageUrl: url,
            //   height: expandedHeight,
            //   width: MediaQuery.of(context).size.width,
            //   fit: BoxFit.cover,
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //       Center(
            //     child: Container(
            //       height: 50.0,
            //       width: 50.0,
            //       child: CircularProgressIndicator(
            //           strokeWidth: 1.0,
            //           value: downloadProgress.progress,
            //           valueColor: AlwaysStoppedAnimation(Colors.grey)),
            //     ),
            //   ),
            //   errorWidget: (context, url, error) => Icon(
            //     Icons.error_outline_rounded,
            //     color: Colors.grey,
            //   ),
            // ),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/loader.gif",
              placeholderScale: 0.5,
              image: url,
              fit: BoxFit.cover,
              height: expandedHeight,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Positioned(
          top: containerTop(shrinkOffset, size) - size.height * 0.1, //110.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: size.height * 0.14, //180.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent
                ])),
          ),
        ),
        Positioned(
          top: containerTop(shrinkOffset, size),
          left: 0.0,
          right: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: roundedContainerHeight,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                userId: post.userId,
                              )));
                },
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(ownerUrl),
                ),
                title: Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: size.width * 0.04
                  ),
                ),
                subtitle: Text(
                  "Posted " + readTimestamp(post.timestamp) + " ago", //email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                    //fontSize: size.width * 0.04
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isPostOwner
                        ? const Text("")
                        : IconButton(
                            icon: isLiked
                                ? const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.teal,
                                  )
                                : const Icon(
                                    Icons.favorite_border_rounded,
                                    color: Colors.grey,
                                  ),
                            onPressed: onPressed,
                          ),
                    IconButton(
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () => sharePost(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: containerTop(shrinkOffset, size) - size.height * 0.095, //70.0,
          left: size.width * 0.075, //20.0,
          child: Container(
            width: MediaQuery.of(mContext).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: post.price == ""
                  ? ListTile(
                      title: Text(
                        post.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          //fontSize: size.width * 0.047,//20.0,
                          fontWeight: FontWeight.w600,
                          //letterSpacing: 1.2,
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: size.width * 0.07 //25.0
                            ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                          ),
                          offset: const Offset(0.0, 0.0),
                          onSelected: choiceAction,
                          itemBuilder: (BuildContext context) {
                            return Option.options.map((String choice) {
                              bool isName = choice == Option.name;

                              return PopupMenuItem<String>(
                                value: choice,
                                child: ListTile(
                                  leading: isName
                                      ? const Icon(
                                          Icons.notes_rounded,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.red,
                                        ),
                                  title: Text(
                                    choice,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: isName
                                      ? const Text("Search by name")
                                      : const Text("Search by Coordinates"),
                                ),
                              );
                            }).toList();
                          },
                        ),
                        // child: IconButton(
                        //     icon: Icon(
                        //       Icons.location_on,
                        //       color: Colors.white70,
                        //     ),
                        //     onPressed: () => MapUtils.openMap(post.latitude, post.longitude)
                        // ),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        post.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          //fontSize: size.width * 0.047,//20.0,
                          fontWeight: FontWeight.w600,
                          //letterSpacing: 1.2,
                        ),
                      ),
                      subtitle: Text(
                        "${post.currency} ${post.price} ${post.payPeriod}",
                        style: const TextStyle(
                            color: Colors.white70,
                            //fontSize: size.width * 0.038,//15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: size.width * 0.07 //25.0
                            ),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                          ),
                          offset: Offset(0.0, 0.0),
                          onSelected: choiceAction,
                          itemBuilder: (BuildContext context) {
                            return Option.options.map((String choice) {
                              bool isName = choice == Option.name;

                              return PopupMenuItem<String>(
                                value: choice,
                                child: ListTile(
                                  leading: isName
                                      ? Icon(
                                          Icons.notes_rounded,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.red,
                                        ),
                                  title: Text(
                                    choice,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: isName
                                      ? Text("Search by name")
                                      : Text("Search by Coordinates"),
                                ),
                              );
                            }).toList();
                          },
                        ),
                        // child: IconButton(
                        //     icon: Icon(
                        //       Icons.location_on,
                        //       color: Colors.white70,
                        //     ),
                        //     onPressed: () => MapUtils.openMap(post.latitude, post.longitude)
                        // ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => MediaQuery.of(mContext).size.height * 0.3;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
