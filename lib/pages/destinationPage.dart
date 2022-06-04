// ignore_for_file: file_names

import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/GoogleMaps.dart';
import 'package:gotour/models/LocalityModel.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/PostType.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/pages/searchPage.dart';
import 'package:gotour/pages/weatherDetailsPage.dart';
import 'package:gotour/providers/localityProvider.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/weatherAssistant/weatherAssistant.dart';
import 'package:gotour/weatherAssistant/weatherIconsManager.dart';
import 'package:gotour/widgets/LocalityWidget.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/customAppbar.dart';
import 'package:gotour/widgets/destinationItem.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:gotour/widgets/postData.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weather/weather.dart';

import 'home.dart';

class DestinationPage extends StatefulWidget {
  final Destination destination;

  const DestinationPage({
    Key key,
    this.destination,
  }) : super(key: key);

  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  // bool loading = false;
  // bool loadingOldPost = false;
  //Future futurePostResults;
  //String type;
  // bool localityLoading = false;
  // bool deleting = false;
  //Future futureLocalityResults;
  //final PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  // final LocalityDatabaseManager localityDatabaseManager =
  //     LocalityDatabaseManager();
  ScrollController _scrollController;
  bool lastStatus = true;
  //BannerAd banner;
  Weather weather;
  WeatherAssistant weatherAssistant = WeatherAssistant();
  WeatherIconsManager weatherIconsManager = WeatherIconsManager();

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

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //getAllPosts();

    super.initState();
  }

  getWeatherInfo() async {
    weather = await weatherAssistant.getCurrentWeatherInfo(
        widget.destination.city, widget.destination.country);

    print(
        "=========================${weather.weatherIcon}=====================");
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    //banner?.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  // Future<void> getAllPosts() async {
  //   setState(() {
  //     loading = true;
  //     type = "";
  //   });

  //   await updateLocalities();

  //   await PostProvider().updateDestinationPosts(
  //       widget.destination.city, widget.destination.country);

  //   await getWeatherInfo();

  //   setState(() {
  //     loading = false;
  //   });
  // }

  // loadOldPosts() async {
  //   setState(() {
  //     loadingOldPost = true;
  //     type = "";
  //   });

  //   await PostProvider().loadOldDestinationPosts(widget.destination.city, widget.destination.country);

  //   setState(() {
  //     loadingOldPost = false;
  //     // futurePostResults = postDataBaseManager.getDestinationPosts(
  //     //     widget.destination.city, widget.destination.country);
  //   });
  // }

  // updateLocalities() async {
  //   setState(() {
  //     localityLoading = true;
  //   });

  //   await LocalityProvider()
  //       .updateLocalities(widget.destination.city, widget.destination.country);

  //   setState(() {
  //     // futureLocalityResults = localityDatabaseManager.getLocalities(
  //     //     widget.destination.city, widget.destination.country);
  //     localityLoading = false;
  //   });
  // }

  // getFilteredResult() async {
  //   setState(() {
  //     loading = true;
  //   });
  //
  //   var allPosts = postDataBaseManager.searchByType(
  //       type, widget.destination.city, widget.destination.country);
  //
  //   setState(() {
  //     loading = false;
  //     futurePostResults = allPosts;
  //   });
  // }

  displayCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: List.generate(PostType.types.length, (index) {
          bool isSelected =
              PostType.types[index] == context.watch<CategoryType>().type;

          return InkWell(
            onTap: () {
              context.read<CategoryType>().changeType(PostType.types[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey,
                        width: 2.0)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Text(
                      PostType.types[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.teal : Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // showOptions(mContext, String postName, String postId) {
  //   return showDialog(
  //     context: mContext,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: Text(
  //           "Edit $postName",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
  //         ),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //               child: Text("Delete Post"),
  //               onPressed: () => deletePost(postId)),
  //           SimpleDialogOption(
  //             child: Text("Cancel"),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  // deletePost(String postId) async {
  //   setState(() {
  //     deleting = true;
  //   });
  //
  //   await postDataBaseManager.deletePost(postId);
  //
  //   await storageReference.child(postId).delete();
  //
  //   await postsReference.doc(postId).delete();
  //
  //   Fluttertoast.showToast(msg: "Post deleted successfully");
  //
  //   setState(() {
  //     deleting = false;
  //     futurePostResults = postDataBaseManager.getDestinationPosts(
  //         widget.destination.city, widget.destination.country);
  //   });
  // }

  // void choiceAction(String choice) {
  //   setState(() {
  //     type = choice;
  //   });

  //   //getFilteredResult();
  // }

  displayWeather() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (context) => WeatherDetailsPage(
                    weather: weather,
                    destination: widget.destination,
                  ));

          Navigator.push(context, route);
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.black26,
            // border: Border.all(
            //   color: Colors.teal,
            //   width: 1.0
            // )
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  weatherIconsManager.manageIcon(weather, 16.0),
                  // BoxedIcon(
                  //   WeatherIcons.fromString(
                  //       weather.weatherMain.toLowerCase(),
                  //       // Fallback is optional, throws if not found, and not supplied.
                  //       fallback: WeatherIcons.na
                  //   ),
                  //   size: 17.0,
                  // ),
                  //SizedBox(width: 5.0,),
                  //Image.network("http://openweathermap.org/img/w/${weather.weatherIcon}.png", height: 50.0, width: 50.0,),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "${weather.temperature.celsius.round().toString()} \u2103",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<LocalityProvider>()
        .updateLocalities(widget.destination.city, widget.destination.country);

    context.read<PostProvider>().updateDestinationPosts(
        widget.destination.city, widget.destination.country);

    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Color color = isBright ? Colors.black : Colors.white;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if (sizeInfo.isDesktop) {
          return DesktopViewDestinationPage(
            destination: widget.destination,
            displayWeather: weather != null ? displayWeather() : Container(),
            displayCategories: displayCategories(),
            displayLocalities: DisplayLocalities(
              updateLocalities: () => context
                  .read<LocalityProvider>()
                  .updateLocalities(
                      widget.destination.city, widget.destination.country),
              destination: widget.destination,
            ),
            destinationPosts: DisplayDestinationPosts(
              destination: widget.destination,
              loadOldPosts: () => context
                  .read<PostProvider>()
                  .loadOldDestinationPosts(
                      widget.destination.city, widget.destination.country),
              updateLocalities: () => context
                  .read<LocalityProvider>()
                  .updateLocalities(
                      widget.destination.city, widget.destination.country),
              getAllPosts: () {
                context.read<PostProvider>().updateDestinationPosts(
                    widget.destination.city, widget.destination.country);

                context.read<LocalityProvider>().updateLocalities(
                    widget.destination.city, widget.destination.country);
              },
              type: context.watch<CategoryType>().type,
            ),
          );
        }

        return Scaffold(
          body: NestedScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  stretch: true,
                  elevation: 0.0,
                  title: ListTile(
                    title: Text(
                      widget.destination.city,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isShrink ? Colors.teal : Colors.transparent),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.airplanemode_active,
                          size: 15.0,
                          color: isShrink ? Colors.grey : Colors.transparent,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          widget.destination.country,
                          style: TextStyle(
                            color: isShrink ? Colors.grey : Colors.transparent,
                            //fontSize: 15.0
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: color,
                          ),
                          //iconSize: 25.0,
                          color: color,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.45,
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.search_rounded,
                        color: color,
                      ),
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => SearchPage());
                        Navigator.push(context, route);
                      },
                    ),
                    weather != null ? displayWeather() : Container()
                    // PopupMenuButton<String>(
                    //   icon: Icon(Icons.sort, color: color, size: 25.0,),
                    //   offset: Offset(0.0, 0.0),
                    //   onSelected: choiceAction,
                    //   itemBuilder: (BuildContext context){
                    //     return PostType.types.map((String choice){
                    //       return PopupMenuItem<String>(
                    //         value: choice,
                    //         child: Text(choice),
                    //       );
                    //     }).toList();
                    //   },
                    // )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            ),
                          ),
                          child: Hero(
                            tag: widget.destination.imageUrl,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              ),
                              // child: CachedNetworkImage(
                              //   imageUrl: widget.destination.imageUrl,
                              //   // height: size.height * 0.21,
                              //   // width: size.width * 0.44,
                              //   fit: BoxFit.cover,
                              //   progressIndicatorBuilder:
                              //       (context, url, downloadProgress) => Center(
                              //     child: Container(
                              //       height: 50.0,
                              //       width: 50.0,
                              //       child: CircularProgressIndicator(
                              //           strokeWidth: 1.0,
                              //           value: downloadProgress.progress,
                              //           valueColor:
                              //               AlwaysStoppedAnimation(Colors.grey)),
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
                                image: widget.destination.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
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
                          left: 20.0,
                          bottom: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.destination.city,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      //fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      //letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.white70,
                                    size: 5.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    DestinationItem()
                                        .createState()
                                        .readTimestamp(
                                            widget.destination.timestamp),
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        //fontSize: 13.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.airplanemode_active,
                                    //size: 15.0,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    widget.destination.country,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      //fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text(
                                  widget.destination.description.trimRight(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    //fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            right: 20.0,
                            bottom: 20.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                              ),
                              onPressed: () => MapUtils.openPlace(
                                  widget.destination.city,
                                  widget.destination.country),
                            )),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(widget: displayCategories()),
                )
              ];
            },
            body: RefreshIndicator(
              child: DisplayDestinationPosts(
                destination: widget.destination,
                loadOldPosts: () => context
                    .read<PostProvider>()
                    .loadOldDestinationPosts(
                        widget.destination.city, widget.destination.country),
                updateLocalities: () => context
                    .read<LocalityProvider>()
                    .updateLocalities(
                        widget.destination.city, widget.destination.country),
                getAllPosts: () {
                  context.read<PostProvider>().updateDestinationPosts(
                      widget.destination.city, widget.destination.country);

                  context.read<LocalityProvider>().updateLocalities(
                      widget.destination.city, widget.destination.country);
                },
                type: context.watch<CategoryType>().type,
              ),
              onRefresh: () {},
            ),
          ),
        );
      },
    );
  }
}

class CategoryType with ChangeNotifier {
  String _type = "";

  String get type => _type;

  void changeType(String choice) {
    _type = choice;
    notifyListeners();
  }
}

class DesktopViewDestinationPage extends StatelessWidget {
  final Destination destination;
  final Widget destinationPosts;
  final Widget displayWeather;
  final Widget displayCategories;
  final Widget displayLocalities;

  const DesktopViewDestinationPage(
      {Key key,
      this.destination,
      this.destinationPosts,
      this.displayWeather,
      this.displayCategories,
      this.displayLocalities})
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
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Text("${destination.city}, ${destination.country}",
                    //       style: Theme.of(context).textTheme.headline5),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Hero(
                              tag: destination.imageUrl,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/loader.gif",
                                  placeholderScale: 0.5,
                                  image: destination.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
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
                            left: 20.0,
                            bottom: 10.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      destination.city,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .apply(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.white70,
                                      size: 5.0,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      DestinationItem()
                                          .createState()
                                          .readTimestamp(destination.timestamp),
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.airplanemode_active,
                                      size: 15.0,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      destination.country,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        //fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 50.0,
                                  width: size.width * 0.6,
                                  child: Text(
                                    destination.description.trimRight(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      //fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              right: 20.0,
                              bottom: 20.0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                ),
                                onPressed: () => MapUtils.openPlace(
                                    destination.city, destination.country),
                              )),
                          Positioned(
                            right: 20.0,
                            top: 20.0,
                            child: displayWeather,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 50.0,
                        width: size.width,
                        child: displayCategories),

                    displayLocalities,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 5,
                          child: destinationPosts,
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

class DisplayDestinationPosts extends StatelessWidget {
  final Destination destination;
  // final bool localityLoading;
  // final bool loadingOldPost;
  final Function updateLocalities;
  final Function getAllPosts;
  final String type;
  // final bool deleting;
  final Function loadOldPosts;

  const DisplayDestinationPosts(
      {Key key,
      this.destination,
      // this.localityLoading,
      // this.loadingOldPost,
      this.updateLocalities,
      this.getAllPosts,
      this.type,
      //this.deleting,
      this.loadOldPosts})
      : super(key: key);

  displayLocalities() {
    return DisplayLocalities(
      updateLocalities: updateLocalities,
      destination: destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sizeInfo.isDesktop ? Container() : displayLocalities(),
              // Container(
              //   height: 50.0,
              //   width: MediaQuery.of(context).size.width,
              //   child: displayCategories(),
              // ),
              FutureBuilder(
                future: context.watch<PostProvider>().getDestinationPosts(
                    type, destination.city, destination.country),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return circularProgress();
                  } else {
                    List<Post> postList = dataSnapshot.data;

                    List<PostData> postDataList =
                        List.generate(postList.length, (index) {
                      Post post = postList[index];

                      return PostData(
                        post: post,
                        onPressed: () {}, //=>
                        //showOptions(context, post.name, post.postId),
                      );
                    });

                    if (postList.isEmpty) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Image(
                              image: AssetImage("assets/images/nodata.png"),
                              height: 100.0,
                              width: 100.0,
                            ),
                            const Text(
                              "No Data",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 17.0),
                            ),
                            //AdLayout(banner: banner),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              //width: 250.0,
                              height: 60.0,
                              alignment: Alignment.center,
                              child: RaisedButton.icon(
                                elevation: 5.0,
                                onPressed: getAllPosts,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0)),
                                color: Colors.teal,
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "retry",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: postDataList,
                            ),
                            //AdLayout(banner: banner),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RaisedButton.icon(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  elevation: 6.0,
                                  onPressed: loadOldPosts,
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
                            )
                          ],
                        ),
                      );
                    }
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class DisplayLocalities extends StatelessWidget {
  //final bool loadingOldPost;
  final Function updateLocalities;
  final Destination destination;

  const DisplayLocalities({Key key, this.updateLocalities, this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .watch<LocalityProvider>()
          .getLocalities(destination.city, destination.country),
      builder: (BuildContext context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Container(
            child: circularProgress(),
          );
        } else {
          List<Locality> localities = dataSnapshot.data;

          if (localities.isEmpty) {
            return Container();
          } else {
            return ResponsiveBuilder(
              builder: (context, sizeInfo) {
                return SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.22,
                  // width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizeInfo.isDesktop
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Localities",
                                  style: Theme.of(context).textTheme.headline6),
                            )
                          : Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: localities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Locality locality = localities[index];

                                  return LocalityWidget(
                                    locality: locality,
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 60.0,
                                  alignment: Alignment.center,
                                  child: RaisedButton.icon(
                                    elevation: 5.0,
                                    onPressed: updateLocalities,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35.0)),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.teal,
                                    ),
                                    label: Text(
                                      "Load More",
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({this.widget});

  final Widget widget;

  @override
  double get minExtent => 50.0;
  @override
  double get maxExtent => 50.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: widget,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
