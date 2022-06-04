// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/Options.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/providers/feedProvider.dart';
import 'package:gotour/providers/postProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/feedLayout.dart';
import 'package:gotour/widgets/postCard.dart';
import 'package:gotour/widgets/postData.dart';

import 'home.dart';

class UserPosts extends StatefulWidget {
  final String userId;
  final Account user;

  const UserPosts({Key key, this.userId, this.user}) : super(key: key);

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  //final PostDataBaseManager _postDataBaseManager = PostDataBaseManager();
  //Future futureUserPosts;
  bool loading = false;
  bool isList = true;

  @override
  void initState() {
    super.initState();

    getPosts();
  }

  Future<void> getPosts() async {
    setState(() {
      loading = true;
    });

    await PostProvider().updateUserPost(widget.userId);

    setState(() {
      loading = false;
      //futureUserPosts = _postDataBaseManager.getUserPosts(widget.userId);
    });
  }

  loadOldPosts() async {
    setState(() {
      loading = true;
    });
    
    await PostProvider().loadOldUserPosts(widget.userId);

    setState(() {
      loading = false;
      //futureUserPosts = _postDataBaseManager.getUserPosts(widget.userId);
    });
  }

  currentUserPosts() {
    return FutureBuilder(
      future: PostProvider().getUserPosts(widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          List<Post> postsList = snapshot.data;

          print(postsList.length);

          if (postsList.isEmpty) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Image(
                    image: AssetImage("assets/images/nodata.png"),
                    height: 100.0,
                    width: 100.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "No Posts",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
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
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: postsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = postsList[index];

                      return isList
                          ? PostData(
                              post: post,
                              onPressed:
                                  () {} //=> showOptions(context, post.name, post.postId),
                              )
                          : PostCard(
                              post: post,
                            );
                    },
                  ),
                  loading
                      ? const Text("")
                      : Center(
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
                        ),
                  const SizedBox(
                    height: 30.0,
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }

  choiceAction(String choice) {
    if (choice == DisplayType.list) {
      setState(() {
        isList = true;
      });
    } else {
      setState(() {
        isList = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    bool isVerified = widget.user.posts > 15;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.user.username.trimRight(),
              style: TextStyle(color: isBright ? Colors.black : Colors.white),
            ),
            isVerified
                ? Icon(
                    Icons.verified_rounded,
                    color: Colors.teal.shade700,
                  )
                : Text("")
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.grey,
            ),
            offset: const Offset(0.0, 0.0),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return DisplayType.displayTypes.map((String choice) {
                bool isList = choice == DisplayType.list;

                return PopupMenuItem<String>(
                  value: choice,
                  child: ListTile(
                    leading: isList
                        ? const Icon(
                            Icons.list,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.photo,
                            color: Colors.grey,
                          ),
                    title: Text(
                      choice,
                    ),
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getPosts,
        child: currentUserPosts(),
      ),
    );
  }
}

class UserFeedPosts extends StatefulWidget {
  final String userId;
  final Account user;

  const UserFeedPosts({Key key, this.userId, this.user}) : super(key: key);

  @override
  _UserFeedPostsState createState() => _UserFeedPostsState();
}

class _UserFeedPostsState extends State<UserFeedPosts> {
  //final FeedDatabaseManager _feedDatabaseManager = FeedDatabaseManager();
  Future<List<Feed>> futureFeedPosts;
  bool loading;

  @override
  void initState() {
    super.initState();

    getPosts();
  }

  Future<void> getPosts() async {
    setState(() {
      loading = true;
    });

    await FeedProvider().updateUserPost(widget.userId);

    setState(() {
      loading = false;
      futureFeedPosts = FeedProvider().getFeedPosts("userFeed");
    });
  }

  loadOldPosts() async {
    setState(() {
      loading = true;
    });

    await FeedProvider().loadOldUserFeed(widget.userId);

    setState(() {
      loading = false;
      futureFeedPosts =  FeedProvider().getFeedPosts("userFeed");
    });
  }

  currentUserPosts() {
    return FutureBuilder(
      future: futureFeedPosts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          List<Feed> postsList = snapshot.data;

          if (postsList.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Image(
                    image: AssetImage("assets/images/nodata.png"),
                    height: 100.0,
                    width: 100.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "No Posts",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
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
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: postsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Feed feed = postsList[index];

                      return FeedLayout(
                        feed: feed,
                      );
                    },
                  ),
                  loading
                      ? const Text("")
                      : Center(
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
                        ),
                  const SizedBox(
                    height: 30.0,
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
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    bool isVerified = widget.user.posts > 15;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.user.username.trimRight(),
              style: TextStyle(color: isBright ? Colors.black : Colors.white),
            ),
            isVerified
                ? Icon(
                    Icons.verified_rounded,
                    color: Colors.teal.shade700,
                  )
                : const Text("")
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        onRefresh: getPosts,
        child: currentUserPosts(),
      ),
    );
  }
}
