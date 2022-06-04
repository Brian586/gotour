// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/favouritesPage.dart';
import 'package:gotour/pages/userPosts.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'editProfilePage.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({@required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  //final PostDataBaseManager _postDataBaseManager = PostDataBaseManager();
  bool loading = false;
  // Future futureFavourites;
  // Future futureUserPosts;
  Future futureUser;
  // ScrollController _scrollController;
  // bool lastStatus = true;
  // TabController _tabController;

  @override
  void initState() {
    super.initState();

    // _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);
    // _tabController = TabController(length: 2, vsync: this);

    getAllProfilePosts();
  }

  @override
  void dispose() {
    //_scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  // _scrollListener() {
  //   if (isShrink != lastStatus) {
  //     setState(() {
  //       lastStatus = isShrink;
  //     });
  //   }
  // }
  //
  // bool get isShrink {
  //   return _scrollController.hasClients &&
  //       _scrollController.offset > (200 - kToolbarHeight);
  // }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });

    Future user = usersReference.doc(widget.userId).get();

    //await updateUserPost();

    setState(() {
      loading = false;
      //futureUserPosts = _postDataBaseManager.getUserPosts();
      // futureFavourites = _postDataBaseManager.getFavourites();
      futureUser = user;
    });
  }

  showContactDetails(BuildContext context, Account user) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Contact",
              style: TextStyle(
                  color: Colors.teal.shade700, fontWeight: FontWeight.bold),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.chat_bubble_outline_outlined,
                    color: Colors.teal.shade700,
                  ),
                  title: Text("Live Chat"),
                ),
                ListTile(
                  onTap: () => launch("tel:${user.phone}"),
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal.shade700,
                  ),
                  title: Text("Call"),
                  subtitle: Text(user.phone),
                ),
                ListTile(
                  onTap: () => launch("sms:${user.phone}"),
                  leading: Icon(
                    Icons.sms_outlined,
                    color: Colors.teal.shade700,
                  ),
                  title: Text("Send Offline text"),
                  subtitle: Text(user.phone),
                ),
                ListTile(
                  onTap: () => launch("mailto:${user.email}"),
                  leading: Icon(
                    Icons.email_outlined,
                    color: Colors.teal.shade700,
                  ),
                  title: Text("Send email"),
                  subtitle: Text(user.email),
                ),
              ],
            ),
          );
        });
  }

  createProfileTopView(Size size) {
    return FutureBuilder(
      future: futureUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: size.height * 0.5,
            width: size.width,
            child: Center(
              child: circularProgress(),
            ),
          );
        } else {
          Account user = Account.fromDocument(snapshot.data);

          bool isCurrentOnlineUser = GoTour.account.id == widget.userId;
          bool isVerified = user.posts > 15;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/background.jpg"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: size.height * 0.2,
                      //color: Colors.black54,
                      child: Center(
                        child: Container(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.15),
                              image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/profile.png"),
                                  fit: BoxFit.cover),
                              border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 3.0)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.15),
                            // child: CachedNetworkImage(
                            //   imageUrl: user.url,
                            //   width: size.width * 0.3,
                            //   height: size.width * 0.3,
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
                              placeholder: "assets/images/profile.png",
                              width: size.width * 0.3,
                              height: size.width * 0.3,
                              image: user.url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.username,
                    style: GoogleFonts.fredokaOne(fontSize: 17.0),
                  ),
                  isVerified
                      ? Icon(
                          Icons.verified_rounded,
                          color: Colors.teal.shade700,
                          size: 20.0,
                        )
                      : Text("")
                ],
              ),
              Text(user.profileName),
              //Text(user.phone),
              //Text(widget.gCurrentUser.email),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "followers",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            user.followers.toString(),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "following",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            user.following.toString(),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "posts",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            user.posts.toString(),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isCurrentOnlineUser
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()));
                          },
                          child: Container(
                            height: 30.0,
                            //width: 100.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border:
                                    Border.all(color: Colors.teal, width: 2.0)),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30.0,
                      //width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.teal, width: 2.0)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Follow",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () => showContactDetails(context, user),
                    child: Container(
                      height: 30.0,
                      //width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.teal, width: 2.0)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Contact",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 2.0,
                ),
              ),
              CustomCard(
                url: "assets/images/posts.jpg",
                subTitle: user.posts.toString(),
                title: "Posts",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPosts(
                                user: user,
                                userId: user.id,
                              )));
                },
              ),
              CustomCard(
                url: "assets/images/feed.jpg",
                subTitle: "See Feed Posts",
                title: "Feed Posts",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserFeedPosts(
                                user: user,
                                userId: user.id,
                              )));
                },
              ),
              isCurrentOnlineUser
                  ? CustomCard(
                      url: "assets/images/fav.jpg",
                      subTitle: "See Your Favourite Posts",
                      title: "Favourites",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouritesPage()));
                      },
                    )
                  : Text("")
              // ListTile(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> UserPosts(gCurrentUser: widget.gCurrentUser, user: user, userId: user.id,)));
              //   },
              //   title: Text("Posts", style: TextStyle(fontWeight: FontWeight.bold),),
              //   subtitle: Text("See Posts"),
              //   trailing: Text(user.posts.toString()),
              // ),
              // ListTile(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=> UserFeedPosts(
              //       gCurrentUser: widget.gCurrentUser,
              //       user: user,
              //       userId: user.id,
              //     )));
              //   },
              //   title: Text("Feed", style: TextStyle(fontWeight: FontWeight.bold),),
              //   subtitle: Text("See Feed Posts"),
              // ),
              // ListTile(
              //   onTap: () {
              //   },
              //   title: Text("Favourites", style: TextStyle(fontWeight: FontWeight.bold),),
              //   subtitle: Text("See Favourite Posts"),
              // )
            ],
          );
        }
      },
    );

    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 15.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(height: 10.0,),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           CircleAvatar(
    //             radius: 45.0,
    //             backgroundImage: NetworkImage(widget.gCurrentUser.url),
    //           ),
    //           Expanded(
    //             child: ListTile(
    //               title: Text(widget.gCurrentUser.username, style: GoogleFonts.fredokaOne(),),
    //               subtitle: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(widget.gCurrentUser.profileName),
    //                   Text(widget.gCurrentUser.phone),
    //                   Text(widget.gCurrentUser.email),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: 10.0,),
    //       Container(
    //         height: 40.0,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5.0),
    //             border: Border.all(
    //                 color: Colors.teal,
    //                 width: 2.0
    //             )
    //         ),
    //         child: Center(child: Text("Edit", style: TextStyle(color: Colors.teal),),),
    //       ),
    //     ],
    //   ),
    // );

    //======================================================================================================

    // return Stack(
    //   children: [
    //     Container(
    //       height: MediaQuery.of(context).size.height * 0.55,
    //       width: MediaQuery.of(context).size.width,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //             fit: BoxFit.cover,
    //             image: AssetImage(
    //               "assets/images/profile.png",
    //             )
    //         ),
    //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),),
    //         //color: Color(0xFF3EBACE),
    //       ),
    //       //=================user Profile image====================//
    //       foregroundDecoration: BoxDecoration(
    //         //color: Colors.lightBlueAccent,
    //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),),
    //           image: DecorationImage(
    //               fit: BoxFit.cover,
    //               image: NetworkImage(widget.gCurrentUser.url)
    //           )
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 0.0,
    //       left: 0.0,
    //       right: 0.0,
    //       child: Container(
    //         height: 150.0,//MediaQuery.of(context).size.height * 0.4,
    //         width: MediaQuery.of(context).size.width,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0),),
    //             gradient: LinearGradient(
    //                 colors: [Colors.black.withOpacity(0.8), Colors.transparent],
    //                 begin: FractionalOffset.bottomCenter,
    //                 end: FractionalOffset.topCenter,
    //             )
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 15.0,
    //       left: 20.0,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(widget.gCurrentUser.username, style: GoogleFonts.fredokaOne(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w400),),
    //           SizedBox(height: 10.0,),
    //           Text(widget.gCurrentUser.profileName, style: TextStyle(color: Colors.white, fontSize: 14.0, ),),
    //           Text(widget.gCurrentUser.phone, style: TextStyle(color: Colors.white, fontSize: 14.0, ),),
    //           Text(widget.gCurrentUser.email, style: TextStyle(color: Colors.white, fontSize: 14.0, ),),
    //         ],
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 10.0,
    //       right: 10.0,
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.push(context, MaterialPageRoute(builder: (context) =>
    //               EditProfilePage(currentOnlineUserId: widget.gCurrentUser.id,)));
    //         },
    //         child: Container(
    //           height: 40.0,
    //           width: 90.0,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(30.0),
    //               color: Colors.black.withOpacity(0.5),
    //               border: Border.all(
    //                 color: Theme.of(context).scaffoldBackgroundColor,
    //                 width: 3.0,
    //               )
    //           ),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Icon(Icons.edit, color: Colors.white, size: 20.0,),
    //               VerticalDivider(color: Colors.white,),
    //               Text("Edit", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),)
    //             ],
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }

  // deletePost(String postId) async {
  //   setState(() {
  //     loading = true;
  //   });
  //
  //   await _postDataBaseManager.deletePost(postId);
  //
  //   await storageReference.child(postId).delete();
  //
  //   await postsReference.document(postId).delete();
  //
  //   Fluttertoast.showToast(msg: "Post deleted successfully");
  //
  //   setState(() {
  //     loading = false;
  //     futureUserPosts = _postDataBaseManager.getUserPosts();
  //     futureFavourites = _postDataBaseManager.getFavourites();
  //   });
  // }

  // showOptions(mContext, String postName, String postId) {
  //   return showDialog(
  //     context: mContext,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: Text("Edit $postName",textAlign: TextAlign.center, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //               child: Text("Delete Post"),
  //               onPressed: () => deletePost(postId)
  //           ),
  //           SimpleDialogOption(
  //             child: Text("Cancel"),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  // currentUserFavourites() {
  //   return FutureBuilder(
  //     future: futureFavourites,
  //     builder: (context, snapshot) {
  //       if(!snapshot.hasData) {
  //         return circularProgress();
  //       }
  //       else
  //       {
  //         List<Post> favouriteList = snapshot.data;
  //
  //         if(favouriteList.length == 0) {
  //           return Container(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Image(
  //                   image: AssetImage("assets/images/nodata.png"),
  //                   height: 100.0,
  //                   width: 100.0,
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(top: 10.0),
  //                   child: Text("No Favourites", style: TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         else
  //         {
  //           return ListView.builder(
  //             physics: BouncingScrollPhysics(),
  //             shrinkWrap: true,
  //             itemCount: favouriteList.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               Post post = favouriteList[index];
  //
  //               return PostData(
  //                 post: post,
  //                 currentUser: widget.gCurrentUser,
  //                 onPressed: ()=> showOptions(context, post.name, post.postId),
  //               );
  //             },
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //title: Text("Profile", style: TextStyle(color: Colors.teal),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))),
            child: Center(
              child: IconButton(
                icon: Icon(
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
      body: SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            createProfileTopView(size),
            // TabBar(
            //   indicatorColor: Colors.teal,
            //   labelColor: Colors.teal,
            //   labelStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16.0),
            //   unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
            //   unselectedLabelColor: Colors.grey,
            //   tabs: [
            //     Tab(text: "Posts",),
            //     Tab(text: "Favourites",)
            //   ],
            //   controller: _tabController,
            //   indicatorSize: TabBarIndicatorSize.tab,
            // ),
            SizedBox(
              height: 30.0,
            ),
            //Divider(color: Colors.grey,),
            //SizedBox(height: 10.0,),

            // Container(
            //   width: size.width,
            //   height: size.height * 5,
            //   child: TabBarView(
            //     children: [
            //       currentUserPosts(),
            //       currentUserFavourites()
            //     ],
            //     controller: _tabController,
            //   ),
            // ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //     body: DefaultTabController(
    //       length: 2,
    //       child: NestedScrollView(
    //         controller: _scrollController,
    //         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //           return [
    //             SliverAppBar(
    //               elevation: 0.0,
    //               leading: IconButton(
    //                   icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   }
    //               ),
    //               title: Text(
    //                 "Profile",
    //                 style: GoogleFonts.fredokaOne(color: isShrink ?  Colors.teal : Colors.transparent),
    //               ),
    //               centerTitle: true,
    //               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //               pinned: true,
    //               expandedHeight: MediaQuery.of(context).size.height * 0.5,
    //               flexibleSpace: FlexibleSpaceBar(
    //                 background: createProfileTopView(),
    //               ),
    //             ),
    //             SliverPersistentHeader(
    //               delegate: _SliverAppBarDelegate(
    //                 TabBar(
    //                   indicatorColor: Colors.teal,
    //                   labelColor: Colors.teal,
    //                   labelStyle: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16.0),
    //                   unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
    //                   unselectedLabelColor: Colors.grey,
    //                   tabs: [
    //                     Tab(text: "My Posts"),
    //                     Tab(text: "Favourites"),
    //                   ],
    //                 ),
    //                 Theme.of(context).scaffoldBackgroundColor,
    //               ),
    //               pinned: true,
    //             ),
    //           ];
    //         },
    //         body: TabBarView(
    //           children: [
    //             currentUserPosts(),
    //             currentUserFavourites()
    //           ],
    //         ),
    //       ),
    //     )
    // );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.color, this.widget);

  final TabBar _tabBar;
  final Widget widget;
  final Color color;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: color,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height * 0.9);

    Offset controlPoint = Offset(size.width / 2, size.height * 0.4);
    Offset endPoint = Offset(size.width, size.height * 0.9);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height * 0.9);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomCard extends StatelessWidget {
  final String url;
  final String title;
  final String subTitle;
  final Function onTap;

  const CustomCard({Key key, this.url, this.title, this.subTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  image: DecorationImage(
                      image: AssetImage(url), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 6.0,
                        blurRadius: 6.0,
                        offset: Offset(2.0, 2.0))
                  ]),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.black38],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredokaOne(color: Colors.white),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
