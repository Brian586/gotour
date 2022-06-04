// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/pages/detailsPage.dart';
import 'package:gotour/shareAssistant/shareAssistant.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    Key key,
    this.post,
  }) : super(key: key);

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var dayFormat = DateFormat('HH:mm a');
    var monthFormat = DateFormat('MMM dd, HH:mm a');
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
        time = diff.inDays.toString() + ' days ago, ${dayFormat.format(date)}';
      }
    } else if ((diff.inDays / 7) > 4) {
      time = monthFormat.format(date);
    } else {
      if (diff.inDays < 14) {
        time = (diff.inDays / 7).floor().toString() + ' week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' weeks ago';
      }
    }

    return time;
  }

  sharePost() async {
    String param = "posts/${post.postId}";

    await ShareAssistant.createAndShareUrl(
      urlParam: param,
      title: post.name,
      description: post.description,
      imageUrl: post.imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => DetailsPage(
                  post: post,
                ));
        Navigator.push(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color:
              isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1.0),
          elevation: 10.0,
          shadowColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Hero(
                tag: post.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  // child: CachedNetworkImage(
                  //   imageUrl: post.imageUrl,
                  //   height: MediaQuery.of(context).size.height * 0.3,
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
                    placeholderScale: 0.5,
                    image: post.imageUrl,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.3,
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
                  height: MediaQuery.of(context).size.height * 0.2,
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
                left: width * 0.01,
                right: width * 0.1,
                child: Container(
                  width: width * 0.8,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(post.ownerUrl),
                    ),
                    title: Text(
                      post.name.trimRight(),
                      style: GoogleFonts.fredokaOne(
                        color: Colors.white,
                        //fontSize: 20.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.currency,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              post.price,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              post.payPeriod,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 5.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              readTimestamp(post.timestamp),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                      ),
                      onPressed: sharePost,
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
