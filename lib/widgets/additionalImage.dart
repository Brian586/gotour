import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class AdditionalImage extends StatelessWidget {

  final File file;
  final Function onPressed;


  AdditionalImage({@required this.file, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Container(
            height: 180.0,
            width: 220.0,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                height: 180.0,
                width: 220.0,
                image: FileImage(file),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: IconButton(icon: Icon(Icons.clear,size: 20.0, color: Colors.white,), onPressed: onPressed),
              ),
            ),
          )
        ],
      ),
    );
  }
}



class AdditionalVideo extends StatefulWidget {

  final File file;
  final Function onPressed;


  AdditionalVideo({@required this.file, @required this.onPressed});

  @override
  _AdditionalVideoState createState() => _AdditionalVideoState();
}

class _AdditionalVideoState extends State<AdditionalVideo> {

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(
        widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });

       // _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  fileSize() {

    int size = widget.file.lengthSync();

    if(size < 1000)
      {
        return size.toString() + " B";
      }
    else if(size >= 1000 && size < 1000000)
      {
        size = (size/1000).round();
        return size.toString() + " KB";
      }
    else if(size >= 1000000)
      {
        size = (size/1000000).round();
        return size.toString() + " MB";
      }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Container(
            // height: 180.0,
            // width: 220.0,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child:   _controller.value.isInitialized
                  ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
              ) : Container(),
            ),
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: IconButton(icon: Icon(Icons.clear,size: 20.0, color: Colors.white,), onPressed: widget.onPressed),
              ),
            ),
          ),
          Positioned(
            bottom: 5.0,
            left: 5.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border.all(
                      color: Colors.white,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    // Wrap the play or pause in a call to `setState`. This ensures the
                    // correct icon is shown
                    setState(() {
                      // If the video is playing, pause it.
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        // If the video is paused, play it.
                        _controller.play();
                      }
                    });
                  },
                  // Display the correct icon depending on the state of the player.
                  child: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Text(fileSize(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }

}
