// ignore_for_file: file_names

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/shareAssistant/imageDownloader.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:uuid/uuid.dart';

class ViewImage extends StatefulWidget {
  final String url;
  final String title;

  const ViewImage({
    Key key,
    this.url,
    this.title,
  }) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  String postId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GoTour.account.id == brian.id
          ? FloatingActionButton(
              onPressed: () {
                MyDownloader().downloadImage(
                  url: widget.url,
                  subDir: "Images",
                  postId: postId,
                );
              },
              child: const Icon(Icons.download),
              backgroundColor: Colors.teal,
            )
          : Container(),
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Center(
        child: Hero(
          tag: widget.url,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                imageProvider: NetworkImage(widget.url),
              )),
        ),
      ),
    );
  }
}

class ViewVideo extends StatefulWidget {
  final String url;
  final String title;

  ViewVideo({this.url, this.title});

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  VideoPlayerController _controller;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
              videoPlayerController: _controller,
              autoPlay: true,
              looping: true,
              materialProgressColors: ChewieProgressColors(
                  playedColor: Colors.teal,
                  bufferedColor: Colors.teal.withOpacity(0.2),
                  handleColor: Colors.teal,
                  backgroundColor: Colors.grey.withOpacity(0.5)));
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: Center(
          child: Hero(
            tag: widget.url,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  )
                : circularProgress(),
          ),
        ),
      ),
    );
  }
}
