// ignore_for_file: file_names

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/pages/feedDetails.dart';
import 'package:gotour/pages/profilePage.dart';
import 'package:gotour/pages/viewImages.dart';
import 'package:gotour/shareAssistant/shareAssistant.dart';
import 'package:gotour/widgets/postCard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FeedLayout extends StatefulWidget {
  final Feed feed;

  const FeedLayout({
    Key key,
    this.feed,
  }) : super(key: key);

  @override
  _FeedLayoutState createState() => _FeedLayoutState();
}

class _FeedLayoutState extends State<FeedLayout> {
  int pageNumber = 1;
  bool isVisible = false;
  CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();

    setState(() {
      widget.feed.urls.shuffle();
    });
  }

  buildHead() {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      userId: widget.feed.publisherID,
                    )));
      },
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: const AssetImage(
            "assets/images/profile.png"), //NetworkImage(widget.feed.ownerUrl),
        backgroundColor: Colors.teal.shade100,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            // child: CachedNetworkImage(
            //   imageUrl: widget.feed.ownerUrl,
            //   height: 40.0,
            //   width: 40.0,
            //   fit: BoxFit.cover,
            //   progressIndicatorBuilder: (context, url, downloadProgress) =>
            //       Container(),
            //   errorWidget: (context, url, error) => Icon(
            //     Icons.error_outline_rounded,
            //     color: Colors.grey,
            //   ),
            // ),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(widget.feed.ownerUrl),
                fit: BoxFit.cover,
              )),
            )),
      ),
      title: Text(
        widget.feed.username.trimRight(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Container(
                  child: Text(
            widget.feed.location,
            maxLines: 2,
          ))),
          const SizedBox(
            width: 5.0,
          ),
          const Icon(
            Icons.circle,
            //color: Colors.white,
            size: 5.0,
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            const PostCard().readTimestamp(widget.feed.timestamp),
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      // trailing: IconButton(
      //   icon: Icon(Icons.more_vert),
      //   onPressed: () {},
      // ),
    );
  }

  getType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "mp4") {
      return true;
    }
    // if (typeString == "mp4") {
    //   return UrlType.VIDEO;
    // }
    else {
      return false;
    }
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      pageNumber = index + 1;
    });
  }

  buildBody(Size size) {
    bool isMany = widget.feed.urls.length > 1;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        return Stack(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: CarouselSlider(
                  items: List.generate(widget.feed.urls.length, (index) {
                    String url = widget.feed.urls[index];
                    bool isVideo = getType(url);

                    if (isVideo) {
                      return VideoWidget(
                        url: url,
                        title: widget.feed.username,
                      );
                    } else {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewImage(
                                          url: url,
                                          title: widget.feed.username,
                                        )));
                          },
                          child: Hero(
                              tag: url,
                              // child: CachedNetworkImage(
                              //   imageUrl: url,
                              //   //height: 300.0,
                              //   width: size.width,
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
                                //placeholderScale: 0.05,
                                image: url,
                                fit: BoxFit.cover,
                                //height: size.height * 0.28,
                                width: size.width,
                              )));
                    }
                  }),
                  carouselController: controller,
                  options: CarouselOptions(
                    height: sizeInfo.isDesktop
                        ? size.height * 0.4
                        : size.height * 0.3, //220.0,
                    //aspectRatio: 16/9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    onPageChanged: onPageChange,
                    //autoPlayInterval: Duration(seconds: 6),
                    //autoPlayAnimationDuration: Duration(milliseconds: 800),
                    //autoPlayCurve: Curves.fastOutSlowIn,
                    //enlargeCenterPage: true,
                    //onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  )),
              // child: ListView.builder(
              //   shrinkWrap: true,
              //   scrollDirection: Axis.horizontal,
              //   itemCount: widget.feed.urls.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     String url = widget.feed.urls[index];
              //     bool isVideo = getType(url);
              //
              //     if(isVideo)
              //       {
              //         return VideoWidget(url: url,);
              //       }
              //     else
              //       {
              //         return Image.network(url);
              //       }
              //   },
              // ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: isMany
                  ? Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black54),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            sizeInfo.isDesktop ? IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 12.0,
                              ),
                              onPressed: () => controller.previousPage(),
                            ) : Container(),
                            Text(
                              "$pageNumber/${widget.feed.urls.length}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            sizeInfo.isDesktop ? IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 12.0,
                              ),
                              onPressed: () => controller.nextPage(),
                            ) : Container(),
                          ],
                        ),
                      )),
                    )
                  : const Text(""),
            )
          ],
        );
      },
    );
  }

  buildDescription() {
    return widget.feed.description == ""
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              widget.feed.description,
              maxLines: 1000,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 6.0,
                  blurRadius: 6.0,
                  offset: Offset(2.0, 2.0))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHead(),
            buildBody(size),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "0 likes",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.circle,
                    //color: Colors.white,
                    size: 5.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "0 comments",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            buildDescription(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    Material(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedDetails(
                                        feed: widget.feed,
                                      )));
                        },
                        icon: const Icon(
                          Icons.comment_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => sharePost(),
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  sharePost() async {
    String param = "feed/${widget.feed.postId}";

    await ShareAssistant.createAndShareUrl(
      urlParam: param,
      title: widget.feed.username,
      description: widget.feed.description,
      imageUrl: widget.feed.urls[0],
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;
  final String title;

  const VideoWidget({Key key, this.url, this.title}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  //VideoPlayerController _controller;
  String fileName;

  // @override
  // void initState() {
  //   super.initState();

  //   getThumbnail();
  // }

  // getThumbnail() async {
  //   await VideoThumbnail.thumbnailFile(
  //     video: widget.url,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.JPEG,
  //     //maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 90,
  //   ).then((value) {
  //     setState(() {
  //       fileName = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.url,
      child: Stack(
        children: [
          fileName == null
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(fileName)), fit: BoxFit.cover)),
                  //child: ,
                ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewVideo(
                            url: widget.url,
                            title: widget.title,
                          )));
            },
            child: const Center(
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 20.0,
                child: Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
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
