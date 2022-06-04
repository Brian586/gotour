// ignore_for_file: file_names

import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/Category.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:gotour/widgets/postData.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'home.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  //final PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  // bool loading = false;
  // bool loadingOld = false;
  //Future futureResults;
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

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    //getPosts();
  }

  // Future<void> getPosts() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   PostProvider().updateCategoryPosts(widget.category.name);

  //   setState(() {
  //     loading = false;
  //     // futureResults =
  //     //     postDataBaseManager.getCategoryPosts(widget.category.name);
  //   });
  // }

  // loadOldPosts() async {
  //   setState(() {
  //     loadingOld = true;
  //   });

  //   PostProvider().loadOldCategoryPosts(widget.category.name);

  //   setState(() {
  //     loadingOld = false;
  //     // futureResults =
  //     //     postDataBaseManager.getCategoryPosts(widget.category.name);
  //   });
  // }

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
  //     futureResults =
  //         postDataBaseManager.getCategoryPosts(widget.category.name);
  //   });
  // }

  // showOptions(mContext, String postName, String postId) {
  //   return showDialog(
  //     context: mContext,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: Text(
  //           "Edit $postName",
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
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

  displayCategoryList() {
    return FutureBuilder(
      future:
          context.watch<PostProvider>().getCategoryPosts(widget.category.name),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Post> postList = dataSnapshot.data;

          if (postList.isEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      onPressed: () => context
                          .read<PostProvider>()
                          .updateCategoryPosts(widget.category.name),
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Post post = postList[index];

                      return PostData(post: post, onPressed: () {} //=>
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
                        onPressed: () => context
                            .read<PostProvider>()
                            .loadOldCategoryPosts(widget.category.name),
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

  @override
  Widget build(BuildContext context) {
    context.read<PostProvider>().updateCategoryPosts(widget.category.name);

    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if (sizeInfo.isDesktop) {
          return DesktopViewCategoryPage(
            getPosts: () => context
                .read<PostProvider>()
                .updateCategoryPosts(widget.category.name),
            displayCategoryList: displayCategoryList(),
            scrollController: _scrollController,
            isShrink: isShrink,
            category: widget.category,
          );
        }

        return Scaffold(
          body: NestedScrollView(
            body: RefreshIndicator(
              child: displayCategoryList(),
              onRefresh: () => context
                  .read<PostProvider>()
                  .updateCategoryPosts(widget.category.name),
            ),
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  stretch: true,
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.25,
                  pinned: true,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.category.name,
                      style: GoogleFonts.fredokaOne(
                        color: isShrink ? Colors.teal : Colors.white,
                        //fontSize: isShrink ? size.width * 0.05 : size.width * 0.045//20.0,
                      ),
                    ),
                    background: Stack(
                      children: [
                        Hero(
                          tag: widget.category.imageUrl,
                          // child: CachedNetworkImage(
                          //   imageUrl: widget.category.imageUrl,
                          //   height: MediaQuery.of(context).size.height * 0.3,
                          //   width: MediaQuery.of(context).size.width,
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
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(widget.category.imageUrl),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 100.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.black54,
                                  Colors.transparent
                                ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
          ),
        );
      },
    );
  }
}

class DesktopViewCategoryPage extends StatelessWidget {
  //final bool loading;
  final Future<void> Function() getPosts;
  final Widget displayCategoryList;
  final ScrollController scrollController;
  final bool isShrink;
  final Category category;

  const DesktopViewCategoryPage(
      {Key key,
      //this.loading,
      this.getPosts,
      this.displayCategoryList,
      this.scrollController,
      this.isShrink,
      this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              body: NestedScrollView(
                body: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: RefreshIndicator(
                        child: displayCategoryList,
                        onRefresh: getPosts,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    )
                  ],
                ),
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      stretch: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
                      expandedHeight: MediaQuery.of(context).size.height * 0.25,
                      pinned: true,
                      floating: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          category.name,
                          style: GoogleFonts.fredokaOne(
                            color: isShrink ? Colors.teal : Colors.white,
                            //fontSize: isShrink ? size.width * 0.05 : size.width * 0.045//20.0,
                          ),
                        ),
                        background: Stack(
                          children: [
                            Hero(
                              tag: category.imageUrl,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(category.imageUrl),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                height: 100.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Colors.black54,
                                      Colors.transparent
                                    ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
