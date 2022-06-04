// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/pages/detailsPage.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PostData extends StatefulWidget {
  final Post post;
  final Function onPressed;

  const PostData({Key key, this.post, @required this.onPressed})
      : super(key: key);

  @override
  _PostDataState createState() => _PostDataState();
}

class _PostDataState extends State<PostData> {
  String timeAgo = "";

  @override
  void initState() {
    super.initState();

    timeAgo = readTimestamp(widget.post.timestamp);
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    //var format = DateFormat('HH:mm a');
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
        time = diff.inDays.toString() + ' day ago';
      } else {
        time = diff.inDays.toString() + ' days ago';
      }
    } else {
      if (diff.inDays < 14) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    Size size = MediaQuery.of(context).size;
    bool isPostOwner = GoTour.account.id == widget.post.userId;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsPage(
                      post: widget.post,
                    )));
      },
      child: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          bool isDesktop = sizeInfo.isDesktop;

          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(
                    isDesktop ? size.width * 0.05 : size.width * 0.1, //40.0,
                    5.0,
                    10.0,
                    5.0),
                //height: size.height * 0.19,//170.0,
                width: double.infinity,
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      isDesktop
                          ? size.width * 0.15
                          : size.width * 0.25, //100.0,
                      10.0,
                      5.0,
                      10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: size.width, //200.0,
                        child: Text(
                          widget.post.name.trimRight(),
                          style: GoogleFonts.fredokaOne(
                              //fontSize: size.width * 0.045,
                              //fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.post.currency,
                            style: const TextStyle(
                              //fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' ${widget.post.price} ',
                            style: const TextStyle(
                              //fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.post.payPeriod,
                            style: const TextStyle(
                              color: Colors.grey,
                              //fontSize: size.width * 0.04,//16.0
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.post.type,
                        style: const TextStyle(
                          color: Colors.grey,
                          //fontSize: size.width * 0.04,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        widget.post.locality,
                        style: const TextStyle(
                          color: Colors.grey,
                          //fontSize: size.width * 0.035,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            //color: Colors.white,
                            size: 5.0,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: isDesktop ? 13.0 : size.width * 0.025,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 10.0,
              //   right: 10.0,
              //   child: isPostOwner ? IconButton(
              //     onPressed: widget.onPressed,
              //     icon: Icon(Icons.edit, color: Colors.grey,),
              //     iconSize: 20.0,
              //   ) : Text("")
              // ),
              Positioned(
                left: isDesktop ? size.width * 0.02 : size.width * 0.05, //20.0,
                top: 15.0,
                bottom: 15.0,
                child: Hero(
                  tag: widget.post.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    // child: CachedNetworkImage(
                    //   imageUrl: widget.post.imageUrl,
                    //   // height: size.height * 0.21,
                    //   width: size.width * 0.27,
                    //   fit: BoxFit.cover,
                    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //       Container(),
                    //   errorWidget: (context, url, error) => Icon(
                    //     Icons.error_outline_rounded,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    child: Image(
                      width: isDesktop
                          ? size.width * 0.15
                          : size.width * 0.27, //110.0,
                      image: NetworkImage(
                        widget.post.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
