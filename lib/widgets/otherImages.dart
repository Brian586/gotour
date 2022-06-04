// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gotour/pages/viewImages.dart';
import 'package:video_player/video_player.dart';

import 'ProgressWidget.dart';

class OtherImages extends StatelessWidget {
  final String url;

  const OtherImages({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewImage(
                        url: url,
                        title: "",
                      )));
        },
        child: Container(
          height: 180.0,
          width: size.width * 0.5, //220.0,
          decoration: BoxDecoration(
            color:
                isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1.0),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: isBright ? Colors.black26 : Colors.black87,
                offset: const Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Hero(
            tag: url,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              // child: CachedNetworkImage(
              //   imageUrl: url,
              //   height: 180.0,
              //   width: 220.0,
              //   fit: BoxFit.cover,
              //   progressIndicatorBuilder: (context, url, downloadProgress) =>
              //       Center(
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
                placeholder: "assets/images/logobw.png",
                image: url,
                fit: BoxFit.cover,
                height: 180.0,
                width: 220.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewVideo(
                        url: widget.url,
                        title: "",
                      )));
        },
        child: Container(
          // height: 180.0,
          // width: 220.0,
          decoration: BoxDecoration(
            color:
                isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1.0),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: isBright ? Colors.black26 : Colors.black87,
                offset: const Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: widget.url,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : circularProgress(),
                ),
              ),
              const Positioned(
                bottom: 10.0,
                left: 10.0,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
