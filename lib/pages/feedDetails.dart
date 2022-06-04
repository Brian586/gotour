// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/feed.dart';
import 'package:gotour/pages/viewImages.dart';
import 'package:gotour/widgets/feedLayout.dart';

class FeedDetails extends StatefulWidget {
  final Feed feed;

  const FeedDetails({Key key, this.feed}) : super(key: key);

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
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

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(
          widget.feed.username,
          style: TextStyle(color: isBright ? Colors.black : Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                              //           valueColor: AlwaysStoppedAnimation(
                              //               Colors.grey)),
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
                                width: size.width,
                              ),
                            ),
                          ));
                    }
                  }),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.3, //220.0,
                    //aspectRatio: 16/9,
                    viewportFraction: 0.85,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    //onPageChanged: onPageChange,
                    //autoPlayInterval: Duration(seconds: 6),
                    //autoPlayAnimationDuration: Duration(milliseconds: 800),
                    //autoPlayCurve: Curves.fastOutSlowIn,
                    //enlargeCenterPage: true,
                    //onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            ListTile(
              title: Text(widget.feed.location),
              subtitle: Text(widget.feed.description),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Comments",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
