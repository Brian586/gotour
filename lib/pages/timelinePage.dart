// ignore_for_file: file_names

import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/Category.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/carouselImage.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/pages/feedUpload.dart';
import 'package:gotour/pages/searchPage.dart';
import 'package:gotour/providers/carouselProvider.dart';
import 'package:gotour/providers/categoryProvider.dart';
import 'package:gotour/providers/destinationProvider.dart';
import 'package:gotour/providers/feedProvider.dart';
import 'package:gotour/providers/load_provider.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/categoryDesign.dart';
import 'package:gotour/widgets/customAppbar.dart';
import 'package:gotour/widgets/destinationItem.dart';
import 'package:gotour/widgets/destination_carousel.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:gotour/widgets/feedLayout.dart';
import 'package:gotour/widgets/hotel_carousel.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../lifeCycleManager.dart';
import '../main.dart';
import 'adventuresHotels.dart';
import 'destinations.dart';
import 'home.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  //bool loading = false;
  //Future<List<CarouselImages>> carouselImages;
  //Future<List<Category>> categoryList;
  //Future futureDiscoverResult;
  //CarouselDatabaseManager carouselDatabaseManager = CarouselDatabaseManager();
  // DestinationDatabaseManager destinationDatabaseManager =
  //     DestinationDatabaseManager();
  //PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  //CategoryDatabaseManager categoryDatabaseManager = CategoryDatabaseManager();
  //LastSeenDBManager lastSeenDBManager = LastSeenDBManager();
  List<dynamic> items = [];
  // String city;
  // String country;
  //bool searchingLocation = false;
  //Future locationResults;
  // RateMyApp _rateMyApp = RateMyApp(
  //     preferencesPrefix: "rateMyApp_",
  //     minDays: 3,
  //     minLaunches: 4,
  //     remindDays: 2,
  //     remindLaunches: 4,
  //     googlePlayIdentifier: "com.brian586.gotour_kenya");
  // BannerAd banner;
  // bool isLive = true;
  // bool isConnected = true;

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
  //           request: adState.request);
  //     });
  //   });
  // }

  @override
  void initState() {
    // _rateMyApp.init().then((_) {
    //   if (_rateMyApp.shouldOpenDialog) {
    //     _rateMyApp.showStarRateDialog(
    //       context,
    //       ignoreNativeDialog: true,
    //       title: "Enjoying Gotour App?",
    //       message: "Please leave a rating!",
    //       dialogStyle: DialogStyle(
    //           titleAlign: TextAlign.center,
    //           messageAlign: TextAlign.center,
    //           messagePadding: EdgeInsets.only(bottom: 20.0)),
    //       starRatingOptions: StarRatingOptions(
    //           starsBorderColor: Colors.teal, starsFillColor: Colors.teal),
    //       onDismissed: () =>
    //           _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    //       actionsBuilder: (context, stars) {
    //         // Triggered when the user updates the star rating.
    //         return [
    //           // Return a list of actions (that will be shown at the bottom of the dialog).
    //           FlatButton(
    //             child: Text('OK'),
    //             onPressed: () async {
    //               if (stars != null) {
    //                 _rateMyApp.save().then((value) => Navigator.pop(context));

    //                 await usersReference
    //                     .doc(GoTour.account.id)
    //                     .collection("rating")
    //                     .add({
    //                   "ratingDate": DateTime.now().millisecondsSinceEpoch,
    //                   "rate": stars.round().toString(),
    //                 });

    //                 if (stars >= 4) {
    //                   _rateMyApp.launchStore();
    //                 } else {
    //                   Fluttertoast.showToast(
    //                       msg: "We appreciate your feedback");
    //                 }
    //               }
    //               // print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
    //               // // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
    //               // // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
    //               await _rateMyApp
    //                   .callEvent(RateMyAppEventType.rateButtonPressed);
    //               Navigator.pop<RateMyAppDialogButton>(
    //                   context, RateMyAppDialogButton.rate);
    //             },
    //           ),
    //         ];
    //       },
    //     );
    //   }
    // });

    super.initState();

    getAllPosts();
  }

  Future<void> getAllPosts() async {
    // Provider.of(context).read<LoadProvider>().setLoading(true);

    // await Provider.of(context).read<CarouselProvider>().updateCarousel();

    // await Provider.of(context).read<CategoryProvider>().updateCategories();

    // await Provider.of(context)
    //     .read<DestinationProvider>()
    //     .updateDestinationDB();

    // await Provider.of(context).read<FeedProvider>().updateFeedDB();

    // await Provider.of(context).read<PostProvider>().updatePostsDB();

    // Provider.of(context).read<LoadProvider>().setLoading(false);

    setState(() {
      items = [
        //=================== DestinationCarousel(),===========================
        const DisplayDestinations(),
        //==================== HotelCarousel(),=============================
        DisplayAdventureHotels(
          heading: "Exclusive Hotels",
          type: "Hotel",
          route: MaterialPageRoute(
              builder: (context) => const AdventuresHotels(
                    title: "Hotel",
                  )),
        ),
        const DisplayCategories(
          a: 0,
          b: 3,
        ),
        const DisplayCategories(
          a: 6,
          b: 9,
        ),
        DisplayAdventureHotels(
          heading: "Adventures",
          type: "Adventure",
          route: MaterialPageRoute(
              builder: (context) => const AdventuresHotels(
                    title: "Adventure",
                  )),
        ),
        const DiscoverMore()
      ];
    });
  }

  // fetchDataFromDatabase() async {
  //   await CarouselProvider().updateCarousel();

  //   await CategoryProvider().updateCategories();

  //   await FeedProvider().updateFeedDB();

  //   await DestinationProvider().updateDestinationDB();

  //   await PostProvider().updatePostsDB();
  // }

  // Future<void> getAllPosts() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     // I am connected to a mobile network

  //     try {
  //       //banner.load();

  //       // await fetchDataFromDatabase();

  //       // Future<List<Destination>> destinations =
  //       //     DestinationProvider().getDestinations();

  //       setState(() {
  //         loading = false;
  //         isConnected = true;
  //         //carouselImages = carouselList;
  //         ;
  //       });
  //     } catch (e) {
  //       print(e.toString());
  //       //Fluttertoast.showToast(msg: e.toString(), webShowClose: true);
  //     }
  //   } else {
  //     // I am connected to a wifi network.

  //     setState(() {
  //       loading = false;
  //       isConnected = false;
  //     });
  //   }
  // }

  moveToUpload() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FeedUpload()));

    //await getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<FeedProvider>(context).updateFeedDB();

    //Provider.of(context).read<LoadProvider>().setLoading(true);

    context.read<CarouselProvider>().updateCarousel();

    context.read<CategoryProvider>().updateCategories();

    context.read<DestinationProvider>().updateDestinationDB();

    context.read<FeedProvider>().updateFeedDB();

    context.read<PostProvider>().updatePostsDB();

    print(
        "========================================REBUILT LAYOUT==================================================================================================================================================================================");

    return ScreenTypeLayout(
      mobile: MobileViewTimeline(
        moveToUpload: moveToUpload,
        // loading: loading,
        // isConnected: isConnected,
        getAllPosts: getAllPosts,
        items: items,
      ),
      tablet: MobileViewTimeline(
        moveToUpload: moveToUpload,
        // loading: loading,
        // isConnected: isConnected,
        getAllPosts: getAllPosts,
        items: items,
      ),
      desktop: DesktopViewTimeline(
        moveToUpload: moveToUpload,
        // loading: loading,
        // isConnected: isConnected,
        getAllPosts: getAllPosts,
        items: items,
      ),
      watch: Container(),
    );
  }

  // displayLocalPlaces() {
  //   return FutureBuilder<QuerySnapshot>(
  //     future: locationResults,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return circularProgress();
  //       } else {
  //         List<Destination> destinationList = [];
  //         snapshot.data.docs.forEach((document) {
  //           Destination destination = Destination.fromDocument(document);
  //           destinationList.add(destination);
  //         });

  //         if (destinationList.isEmpty) {
  //           return const Text("");
  //         } else {
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20.0),
  //                 child: Text(
  //                   "Explore $city, $country",
  //                   style: GoogleFonts.fredokaOne(
  //                     fontSize: 19.0,
  //                   ),
  //                 ),
  //               ),
  //               ListView.builder(
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 shrinkWrap: true,
  //                 itemCount: destinationList.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   Destination destination = destinationList[index];

  //                   return DestinationItem(
  //                     destination: destination,
  //                   );
  //                 },
  //               ),
  //             ],
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  // _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       return Future.error(
  //           'Location permissions are permantly denied, we cannot request permissions.');
  //     } else if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission != LocationPermission.whileInUse &&
  //           permission != LocationPermission.always) {
  //         return Future.error(
  //             'Location permissions are denied (actual value: $permission).');
  //       }
  //     } else {
  //       Position position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);

  //       List<Placemark> placeMarks = await placemarkFromCoordinates(
  //           position.latitude, position.longitude);
  //       Placemark mPlaceMark = placeMarks[0];
  //       String completeAddressInfo =
  //           '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, '
  //           '${mPlaceMark.subLocality} ${mPlaceMark.locality}, '
  //           '${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, '
  //           '${mPlaceMark.postalCode} ${mPlaceMark.country}';
  //       String specificAddress =
  //           '${mPlaceMark.locality}, ${mPlaceMark.country}';
  //       String cityAddress = '${mPlaceMark.locality}';
  //       String countryAddress = '${mPlaceMark.country}';

  //       print(specificAddress);

  //       setState(() {
  //         city = cityAddress;
  //         country = countryAddress;
  //       });
  //     }
  //   } else {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     List<Placemark> placeMarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);
  //     Placemark mPlaceMark = placeMarks[0];
  //     String completeAddressInfo =
  //         '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, '
  //         '${mPlaceMark.subLocality} ${mPlaceMark.locality}, '
  //         '${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, '
  //         '${mPlaceMark.postalCode} ${mPlaceMark.country}';
  //     String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
  //     String cityAddress = '${mPlaceMark.locality}';
  //     String countryAddress = '${mPlaceMark.country}';

  //     print(specificAddress);

  //     setState(() {
  //       city = cityAddress;
  //       country = countryAddress;
  //     });
  //   }
  // }

  // getLocationResults() async {
  //   setState(() {
  //     searchingLocation = true;
  //   });

  //   await _determinePosition();

  //   if (city.isNotEmpty && country.isNotEmpty) {
  //     Future results = destinationsReference
  //         .where("city", isEqualTo: city)
  //         .where("country", isEqualTo: country)
  //         .limit(1)
  //         .get();

  //     setState(() {
  //       locationResults = results;
  //       searchingLocation = false;
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: "Error loading results");

  //     setState(() {
  //       searchingLocation = false;
  //     });
  //   }
  // }
}

class DesktopViewTimeline extends StatefulWidget {
  final Function moveToUpload;
  // final bool loading;
  // final bool isConnected;
  final Future<void> Function() getAllPosts;
  final List<dynamic> items;

  const DesktopViewTimeline(
      {Key key,
      this.moveToUpload,
      // this.loading,
      // this.isConnected,
      this.getAllPosts,
      this.items})
      : super(key: key);

  @override
  _DesktopViewTimelineState createState() => _DesktopViewTimelineState();
}

class _DesktopViewTimelineState extends State<DesktopViewTimeline> {
  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;
    bool loading = context.watch<LoadProvider>().isLoading;

    return Scaffold(
      body: loading
          ? Container()
          : Row(
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
                        showArrow: false,
                      ),
                      preferredSize: Size(size.width, size.height * 0.07),
                    ),
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Explore Your World!",
                                style: Theme.of(context).textTheme.headline4),
                          ),
                          const DisplayCarousel(
                            isShrink: false,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DisplayCategories(
                                      a: 3,
                                      b: 6,
                                    ),
                                    DisplayFeed(
                                      items: widget.items,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.green,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class MobileViewTimeline extends StatefulWidget {
  final Function moveToUpload;
  // final bool loading;
  // final bool isConnected;
  final Future<void> Function() getAllPosts;
  final List<dynamic> items;

  const MobileViewTimeline(
      {Key key,
      this.moveToUpload,
      // this.loading,
      // this.isConnected,
      this.getAllPosts,
      this.items})
      : super(key: key);

  @override
  _MobileViewTimelineState createState() => _MobileViewTimelineState();
}

class _MobileViewTimelineState extends State<MobileViewTimeline> {
  ScrollController _scrollController;
  bool lastStatus = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    //banner?.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  bodyLayout() {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;

    if (true) {
      //TODO: Implement isConnected
      return NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.28,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    decoration: BoxDecoration(
                        color: isShrink
                            ? Colors.transparent
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.grey,
                        ),
                        //iconSize: 25.0,
                        color: Colors.grey,
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                ),
                //iconTheme: IconThemeData(color: Colors.grey),
                centerTitle: false,

                title: Text(
                  "Gotour",
                  style: GoogleFonts.fredokaOne(
                      color: isShrink
                          ? isBright
                              ? Colors.teal.shade700
                              : Colors.white
                          : Colors.transparent),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  //titlePadding: EdgeInsets.all(10.0),
                  background: Stack(
                    children: [
                      DisplayCarousel(
                        isShrink: isShrink,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        //top: 0.0,
                        child: Container(
                          height: 70.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.black54,
                                Colors.transparent
                              ])),
                        ),
                      ),
                      // Center(
                      //   child: Text(
                      //       "Find exciting places to visit in Kenya!",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // )
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.grey,
                    ),
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: Size(
                      MediaQuery.of(context).size.width, size.height * 0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => SearchPage());
                        Navigator.push(context, route);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height:
                            isShrink ? size.height * 0.035 : size.height * 0.04,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: isShrink
                              ? Colors.grey.withOpacity(0.2)
                              : isBright
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.black38,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.search,
                              color: isShrink ? Colors.grey : Colors.white70,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Search here...",
                              style: TextStyle(
                                  color:
                                      isShrink ? Colors.grey : Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: RefreshIndicator(
            onRefresh: widget.getAllPosts,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              //padding: EdgeInsets.symmetric(vertical: 30.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Explore your world!',
                    //style: Theme.of(context).textTheme.title,
                    style: GoogleFonts.fredokaOne(
                      fontSize: size.width * 0.04, //30.0,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const DisplayCategories(
                  a: 3,
                  b: 6,
                ),
                const SizedBox(height: 10.0),
                DisplayFeed(
                  items: widget.items,
                )
              ],
            ),
          ));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/images/nodata.png"),
              height: 100.0,
              width: 100.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text("No Internet"),
            const SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () => widget.getAllPosts,
              child: Container(
                height: 30.0,
                width: 70.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.teal, width: 2.0)),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Retry",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //todo
        drawer: const CustomDrawer(),
        floatingActionButton: GoTour.account.role == "Seller"
            ? FloatingActionButton.extended(
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.white,
                ),
                onPressed: () => widget.moveToUpload,
                label: const Text(
                  "New Post",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.teal,
              )
            : Container(),
        body: bodyLayout());
  }
}

class DisplayFeed extends StatefulWidget {
  final List<dynamic> items;
  //final BannerAd banner;

  const DisplayFeed({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  _DisplayFeedState createState() => _DisplayFeedState();
}

class _DisplayFeedState extends State<DisplayFeed> {
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: context.watch<FeedProvider>().getFeedPosts("feed"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<Feed> feedItems = snapshot.data;

          if (feedItems.isEmpty) {
            return Container();
          } else {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      //int i = (index/4).round();
                      //print(index/4);

                      if (index % 4 == 0 &&
                          (index / 4).round() < widget.items.length) {
                        return widget.items[(index / 4).round()];
                      } else {
                        return Container();
                      }
                    },
                    itemBuilder: (BuildContext context, int index) {
                      Feed feed = feedItems[index];

                      return FeedLayout(
                        feed: feed,
                      );
                    },
                  ),
                  //AdLayout(banner: widget.banner),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton.icon(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        elevation: 0.0,
                        onPressed: () =>
                            context.read<FeedProvider>().loadOldFeed(),
                        icon: const Icon(
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
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}

class DiscoverMore extends StatelessWidget {
  //final Future<List<Category>> future;

  const DiscoverMore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Provider.of<CategoryProvider>(context).updateCategories();

    return FutureBuilder(
      future: context.watch<CategoryProvider>().getCategoryList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<Category> categories = snapshot.data;
          List<Category> finalCat =
              categories.where((cat) => cat.timestamp > 13);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Discover more",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("")
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  children: List.generate(finalCat.length, (index) {
                    Category category = finalCat[index];

                    return DiscoverLayout(
                      category: category,
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          );
        }
      },
    );
  }
}

class DisplayCarousel extends StatelessWidget {
  //final Future<List<CarouselImages>> future;
  final bool isShrink;

  const DisplayCarousel({Key key, this.isShrink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Provider.of<CarouselProvider>(context).updateCarousel();

    return FutureBuilder(
      future: context.watch<CarouselProvider>().getCarouselList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            width: size.width,
            height: size.height * 0.28,
          );
        } else {
          List<CarouselImages> carousels = snapshot.data;

          List<dynamic> _listOfImages = carousels[0].urls;

          List<Widget> images = List.generate(_listOfImages.length, (index) {
            dynamic imageUrl = _listOfImages[index];
            //bool isLive = carouselIndex == index;

            return ResponsiveBuilder(
              builder: (context, sizeInfo) {
                if (sizeInfo.isDesktop) {
                  return FadeInImage.assetNetwork(
                    placeholder: "assets/images/loader.gif",
                    placeholderScale: 0.05,
                    //placeholder: isBright ? "assets/images/holder.png" : "assets/images/holderbw.png",//isBright ? "assets/images/holder.jpg" : "assets/images/holder2.jpg",
                    image: imageUrl,
                    fit: BoxFit.cover,
                    height: size.height * 0.2,
                    width: size.width * 0.5,
                  );
                }

                return Stack(
                  children: [
                    // CachedNetworkImage(
                    //   imageUrl: imageUrl,
                    //   height: size.height * 0.33,
                    //   width: size.width,
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
                    FadeInImage.assetNetwork(
                      placeholder: "assets/images/loader.gif",
                      placeholderScale: 0.1,
                      //placeholder: isBright ? "assets/images/holder.png" : "assets/images/holderbw.png",//isBright ? "assets/images/holder.jpg" : "assets/images/holder2.jpg",
                      image: imageUrl,
                      fit: BoxFit.cover,
                      height: size.height * 0.33,
                      width: size.width,
                    ),
                    Center(
                      child: Container(
                        width: size.width * 0.7,
                        child: Text(
                          info[index],
                          textAlign: TextAlign.start,
                          style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  color: Colors.black54,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 6.0,
                                )
                              ]),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          });

          return ResponsiveBuilder(
            builder: (context, sizeInfo) {
              if (sizeInfo.isDesktop) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.2,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 3.0,
                                  blurRadius: 4.0,
                                  offset: Offset(2.0, 2.0))
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(20.0)),
                                    child: CarouselSlider(
                                        items: images,
                                        options: CarouselOptions(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          //aspectRatio: 16/9,
                                          viewportFraction: 1.0,
                                          initialPage: 0,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: isShrink ? false : true,
                                          autoPlayInterval:
                                              const Duration(seconds: 6),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          //enlargeCenterPage: true,
                                          //onPageChanged: onPageChanged,
                                          scrollDirection: Axis.horizontal,
                                        )),
                                  ),
                                  Positioned(
                                    left: 0.0,
                                    top: 0.0,
                                    bottom: 0.0,
                                    child: Container(
                                      width: size.width * 0.5,
                                      //height: size.height*0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                  right: Radius.circular(20.0)),
                                          gradient: LinearGradient(
                                              colors: [
                                                Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                Colors.transparent
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 15.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Center(
                          child: Text(
                            "Find New & Exciting Places to Visit!",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }

              return CarouselSlider(
                  items: images,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.33,
                    //aspectRatio: 16/9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: isShrink ? false : true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    //enlargeCenterPage: true,
                    //onPageChanged: onPageChanged,
                    scrollDirection: Axis.horizontal,
                  ));
            },
          );
        }
      },
    );
  }
}

class DisplayAdventureHotels extends StatelessWidget {
  final String heading;
  final Route route;
  final String type;

  const DisplayAdventureHotels({
    Key key,
    this.heading,
    this.route,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Provider.of<PostProvider>(context).updatePostsDB();

    return FutureBuilder(
      future: context.watch<PostProvider>().getCategoryPosts(type),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Post> postList = dataSnapshot.data;

          if (postList.isEmpty) {
            return Container();
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10.0),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          heading,
                          style: const TextStyle(
                            //fontSize: size.width * 0.05,//22.0,
                            fontWeight: FontWeight.bold,
                            //letterSpacing: 1.5,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, route);
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.teal,
                              //fontSize: size.width * 0.04,//16.0,
                              fontWeight: FontWeight.w600,
                              //letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.32, //300.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: postList == null ? 0 : postList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Post post = postList[index];

                            return HotelCarousel(
                              eachPost: post,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            //width: 250.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: RaisedButton.icon(
                              elevation: 5.0,
                              onPressed: () {
                                Navigator.push(context, route);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0)),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.teal,
                              ),
                              label: Text(
                                "See All",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            );
          }
        }
      },
    );
  }
}

class DisplayDestinations extends StatelessWidget {
  //final Future<List<Destination>> future;

  const DisplayDestinations({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Provider.of<DestinationProvider>(context).updateDestinationDB();

    return FutureBuilder(
      //todo
      future: context.watch<DestinationProvider>().getDestinations(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Destination> destinationList = dataSnapshot.data;

          if (destinationList.isEmpty) {
            return Container();
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10.0),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Top Destinations',
                          style: TextStyle(
                            //fontSize: size.width * 0.05,//22.0,
                            fontWeight: FontWeight.bold,
                            //letterSpacing: 1.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Destinations()));
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.teal,
                              //fontSize: size.width * 0.04,//16.0,
                              fontWeight: FontWeight.w600,
                              //letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.35, //300.0,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: destinationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Destination destination = destinationList[index];

                            return DestinationCarousel(
                              destination: destination,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            //width: 250.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: RaisedButton.icon(
                              elevation: 5.0,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Destinations()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0)),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.teal,
                              ),
                              label: Text(
                                "See All",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            );
          }
        }
      },
    );
  }
}

class DisplayCategories extends StatefulWidget {
  final int a;
  final int b;
  //final Future<List<Category>> future;

  const DisplayCategories({
    Key key,
    this.a,
    this.b,
    //@required this.future,
  }) : super(key: key);

  @override
  State<DisplayCategories> createState() => _DisplayCategoriesState();
}

class _DisplayCategoriesState extends State<DisplayCategories> {
  @override
  Widget build(BuildContext context) {
    //Provider.of<CategoryProvider>(context).updateCategories();

    return FutureBuilder(
      future: context.watch<CategoryProvider>().getCategoryList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<Category> categories = snapshot.data;
          List<Widget> categoryList = [];

          for (int index = widget.a; index < widget.b; index++) {
            Category category = categories[index];

            categoryList.add(CategoryDesign(
              category: category,
            ));
          }

          return ResponsiveBuilder(
            builder: (context, sizeInfo) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10.0),
                  sizeInfo.isDesktop
                      ? GridView.count(
                          crossAxisCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: categoryList,
                        )
                      : CarouselSlider(
                          items: categoryList,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height *
                                0.2, //220.0,
                            //aspectRatio: 16/9,
                            viewportFraction: 0.85,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: false,
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: false,
                            //onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          )),
                  const SizedBox(height: 10.0),
                ],
              );
            },
          );
        }
      },
    );
  }
}
