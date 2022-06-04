import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/pages/detailsPage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HotelCarousel extends StatefulWidget {
  final Post eachPost;

  const HotelCarousel({Key key,
    this.eachPost,
  }) : super(key: key);

  @override
  _HotelCarouselState createState() => _HotelCarouselState();
}

class _HotelCarouselState extends State<HotelCarousel> {
  String timeAgo = "";

  @override
  void initState() {
    super.initState();

    timeAgo = readTimestamp(widget.eachPost.timestamp);
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
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
      time = diff.inHours.toString() + ' h';
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays < 2) {
        time = diff.inDays.toString() + ' d';
      } else {
        time = diff.inDays.toString() + ' d';
      }
    } else {
      if (diff.inDays < 14) {
        time = (diff.inDays / 7).floor().toString() + ' w';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' w';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        bool isDesktop = sizeInfo.isDesktop;
        return Container(
          margin: const EdgeInsets.all(10.0),
          width: isDesktop ? size.width * 0.2 : size.width * 0.6, //240.0,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                bottom: size.height * 0.01, //15.0,
                child: Container(
                  height: size.height * 0.14, //120.0,
                  width: isDesktop ? size.width * 0.18 : size.width * 0.58, //240.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: isBright ? Colors.black26 : Colors.black87,
                        offset: const Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                    color: isBright
                        ? Colors.white
                        : const Color.fromRGBO(48, 48, 48, 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                      padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.028 //30.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.eachPost.currency,
                                style: const TextStyle(
                                  //fontSize: size.width * 0.04,//18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' ${widget.eachPost.price}  ',
                                style: const TextStyle(
                                  //fontSize: size.width * 0.04,//18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.eachPost.payPeriod,
                                style: const TextStyle(
                                  //fontSize: size.width * 0.04,//18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.eachPost.description.trimRight(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.grey,
                              //fontSize: size.width* 0.032
                            ),
                          )
                        ],
                      )),
                ),
              ),
              InkWell(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          post: widget.eachPost,
                        ));
                    Navigator.push(context, route);
                  },
                  child: Stack(
                    children: [
                      Hero(
                        tag: widget.eachPost.imageUrl,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isBright
                                ? Colors.white
                                : const Color.fromRGBO(48, 48, 48, 1.0),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: isBright ? Colors.black26 : Colors.black87,
                                offset: const Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            // child: CachedNetworkImage(
                            //   imageUrl: widget.eachPost.imageUrl,
                            //   height: size.height * 0.18, //180.0,
                            //   width: size.width * 0.52, //220.0,
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
                              height: size.height * 0.18, //180.0,
                              width: isDesktop ? size.width * 0.15 : size.width * 0.52, //220.0,
                              image: widget.eachPost.imageUrl,
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
                          height: size.height * 0.09, //50.0,
                          //width: 220.0,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                              )),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        child: Container(
                          width: size.width * 0.39,
                          child: Text(
                            widget.eachPost.name.trimRight(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fredokaOne(
                              color: Colors.white,
                              //fontSize: size.width * 0.05,//22.0,
                              //fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 5.0,
                            )
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}
