// ignore_for_file: file_names

import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/GoogleMaps.dart';
import 'package:gotour/models/LocalityModel.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/PostType.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/postData.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class LocalityPage extends StatefulWidget {
  final Locality locality;

  const LocalityPage({
    Key key,
    this.locality,
  }) : super(key: key);

  @override
  _LocalityPageState createState() => _LocalityPageState();
}

class _LocalityPageState extends State<LocalityPage> {
  //final PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  bool loading = false;
  int countLocalities = 0;
  //Future futurePostResults;
  String type;
  ScrollController _scrollController;
  bool lastStatus = true;
  // BannerAd banner;

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

  // @override
  // void dispose() {
  //   super.dispose();
  //   banner?.dispose();
  // }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getAllPosts();

    super.initState();
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

  Future<void> getAllPosts() async {
    setState(() {
      loading = true;
    });

    await PostProvider().updateLocalityPosts(widget.locality.locality, widget.locality.city, widget.locality.country);

    setState(() {
      loading = false;
    });
  }

  loadOldPosts() async {
    setState(() {
      loading = true;
    });

    await PostProvider().loadOldLocalityPosts(widget.locality.locality, widget.locality.city, widget.locality.country);

    setState(() {
      loading = false;
    });
  }

  displayAllPosts() {
    return FutureBuilder(
      future: PostProvider().getLocalityPosts(type, widget.locality.locality, widget.locality.city, widget.locality.country),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Post> postList = dataSnapshot.data;

          if (postList.isEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/images/nodata.png"),
                    height: 100.0,
                    width: 100.0,
                  ),
                  const Text(
                    "No Data",
                    style: TextStyle(color: Colors.grey, fontSize: 17.0),
                  ),
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
                  ListView.builder(
                    itemCount: postList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = postList[index];

                      return PostData(
                        post: post,
                        onPressed: () {}, //=>
                            //showOptions(context, post.name, post.postId),
                      );
                    },
                  ),
                  //AdLayout(banner: banner),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton.icon(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
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
    );
  }

  // deletePost(String postId) async {
  //   setState(() {
  //     loading = true;
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
  //     loading = false;
  //     futurePostResults = postDataBaseManager.getLocalityPosts(
  //         widget.locality.locality,
  //         widget.locality.city,
  //         widget.locality.country);
  //   });
  // }
  //
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

  void choiceAction(String choice) {
    setState(() {
      type = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Color color = isBright ? Colors.black : Colors.white;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 2.0,
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
              expandedHeight: MediaQuery.of(context).size.height / 3,
              pinned: true,
              title: ListTile(
                title: Text(
                  widget.locality.locality,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isShrink ? Colors.teal : Colors.transparent),
                ),
                subtitle: Text(
                  "${widget.locality.city}, ${widget.locality.country}",
                  style: TextStyle(
                    color: isShrink ? Colors.grey : Colors.transparent,
                    //fontSize: 15.0
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort,
                    color: color,
                    size: 25.0,
                  ),
                  offset: const Offset(0.0, 50.0),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return PostType.types.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: widget.locality.imageUrl,
                        child: ClipRRect(
                          //borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0),),
                          // child: CachedNetworkImage(
                          //   imageUrl: widget.locality.imageUrl,
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
                            image: widget.locality.imageUrl,
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
                        height: 100.0,
                        decoration: BoxDecoration(
                            //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0),),
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [
                              Colors.black.withOpacity(0.5),
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
                          Text(
                            widget.locality.locality,
                            style: const TextStyle(
                              color: Colors.white,
                              //fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
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
                                widget.locality.city,
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
                              widget.locality.description.trimRight(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12.0,
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
                          onPressed: () => MapUtils.openLocality(
                              widget.locality.locality,
                              widget.locality.city,
                              widget.locality.country),
                        )),
                  ],
                ),
              ),
            )
          ];
        },
        body: loading
            ? circularProgress()
            : RefreshIndicator(
                child: displayAllPosts(),
                onRefresh: getAllPosts,
              ),
      ),
    );
  }
}
