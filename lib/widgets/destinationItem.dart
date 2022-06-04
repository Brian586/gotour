// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/pages/destinationPage.dart';
import 'package:gotour/shareAssistant/shareAssistant.dart';

class DestinationItem extends StatefulWidget {
  final Destination destination;

  DestinationItem({
    this.destination,
  });

  @override
  _DestinationItemState createState() => _DestinationItemState();
}

class _DestinationItemState extends State<DestinationItem> {
  bool isSharing = false;

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

  sharePlace() async {
    setState(() {
      isSharing = true;
    });

    String param = "destinations/${widget.destination.destinationId}";

    await ShareAssistant.createAndShareUrl(
      urlParam: param,
      title:
          "Come Explore: ${widget.destination.city}, ${widget.destination.country}",
      description: widget.destination.description,
      imageUrl: widget.destination.imageUrl,
    );

    setState(() {
      isSharing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => DestinationPage(
                  destination: widget.destination,
                ));
        Navigator.push(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: isBright ? Colors.white : Color.fromRGBO(48, 48, 48, 1.0),
          elevation: 10.0,
          shadowColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Hero(
                tag: widget.destination.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  // child: CachedNetworkImage(
                  //   imageUrl: widget.destination.imageUrl,
                  //   height: height * 0.3, //300.0,
                  //   width: width,
                  //   fit: BoxFit.cover,
                  //   progressIndicatorBuilder:
                  //       (context, url, downloadProgress) => Center(
                  //     child: Container(
                  //       height: 50.0,
                  //       width: 50.0,
                  //       child: CircularProgressIndicator(
                  //           strokeWidth: 1.0,
                  //           value: downloadProgress.progress,
                  //           valueColor: AlwaysStoppedAnimation(Colors.grey)),
                  //     ),
                  //   ),
                  //   errorWidget: (context, url, error) => Icon(
                  //     Icons.error_outline_rounded,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/loader.gif",
                    image: widget.destination.imageUrl,
                    fit: BoxFit.cover,
                    height: height * 0.3, //300.0,
                    width: width,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: width,
                  height: height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: width * 0.01, //15.0,
                right: width * 0.01,
                child: Container(
                  width: width, //* 0.8,
                  child: ListTile(
                    trailing: isSharing
                        ? Container(
                            height: 20.0,
                            width: 20.0,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                //value: downloadProgress.progress,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white)),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: sharePlace,
                          ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.destination.city,
                          style: GoogleFonts.fredokaOne(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 5.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          readTimestamp(widget.destination.timestamp),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.airplanemode_active,
                              color: Colors.white70,
                              size: 20.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              widget.destination.country,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text(
                          widget.destination.description.trimRight(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        // SizedBox(height: 10.0,),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.thumb_up_alt_outlined,
                        //       color: Colors.white,
                        //       size: 20.0,
                        //     ),
                        //     SizedBox(width: 5.0,),
                        //     Text(
                        //       "0 Likes",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           //fontSize: 10.0,
                        //           fontWeight: FontWeight.w300
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
