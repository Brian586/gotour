// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/customAppbar.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:gotour/widgets/postCard.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'home.dart';

class AdventuresHotels extends StatefulWidget {
  final String title;

  const AdventuresHotels({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _AdventuresHotelsState createState() => _AdventuresHotelsState();
}

class _AdventuresHotelsState extends State<AdventuresHotels> {
  // bool loading = false;
  // bool loadingOld = false;
  // //final PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  // Future<List<Post>> futureResults;
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

  // @override
  // void initState() {
  //   super.initState();

  //   getPosts();
  // }

  // Future<void> getPosts() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   await PostProvider().updateCategoryPosts(widget.title);

  //   setState(() {
  //     loading = false;
  //     //futureResults = postDataBaseManager.getCategoryPosts(widget.title);
  //   });
  // }

  // loadOldPosts() async {
  //   setState(() {
  //     loadingOld = true;
  //   });

  //   PostProvider().loadOldCategoryPosts(widget.title);

  //   setState(() {
  //     loadingOld = false;
  //     //futureResults = postDataBaseManager.getCategoryPosts(widget.title);
  //   });
  // }

  displayList(Future<List<Post>> future) {
    return FutureBuilder(
      future: future,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Post> postList = dataSnapshot.data;

          if (postList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/nodata.png"),
                  height: 100.0,
                  width: 100.0,
                ),
                const Text(
                  "No Posts",
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
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.teal, //Color(0xFF3EBACE),
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
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = postList[index];

                      return PostCard(
                        post: post,
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
                            .loadOldCategoryPosts(widget.title),
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
    context.read<PostProvider>().updateCategoryPosts(widget.title);

    Future<List<Post>> future =
        context.watch<PostProvider>().getCategoryPosts(widget.title);

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if (sizeInfo.isDesktop) {
          return DesktopAdventureHotel(
            displayPosts: displayList(future),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "${widget.title}s",
              style: GoogleFonts.fredokaOne(color: Colors.teal),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () =>
                context.read<PostProvider>().updateCategoryPosts(widget.title),
            child: displayList(future),
          ),
        );
      },
    );
  }
}

class DesktopAdventureHotel extends StatelessWidget {
  final Widget displayPosts;

  const DesktopAdventureHotel({Key key, this.displayPosts}) : super(key: key);

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
                    child: displayPosts,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
