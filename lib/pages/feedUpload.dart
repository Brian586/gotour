// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/home.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/additionalImage.dart';
import 'package:gotour/widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class FeedUpload extends StatefulWidget {
  // final List<SharedMediaFile> sharedFiles;

  const FeedUpload({
    Key key,
  }) : super(key: key);

  @override
  _FeedUploadState createState() => _FeedUploadState();
}

class _FeedUploadState extends State<FeedUpload>
    with AutomaticKeepAliveClientMixin<FeedUpload> {
  final ImagePicker picker = ImagePicker();
  bool loading = false;
  String postId = Uuid().v4();
  int loopCount = 0;
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  List<File> imageList = <File>[];
  List<File> videoList = <File>[];
  List<File> uploadList = <File>[];
  List<String> uploadUrls = <String>[];
  List<File> galleryItems = [];
  //List<AssetPathEntity> collections = [];
  String collectionName = "Recent";
  bool imagesSelected = false;
  List<String> fileLocations = <String>[];

  // @override
  // void initState() {

  //   if(widget.sharedFiles.length > 0)
  //     {
  //       widget.sharedFiles.forEach((element) {
  //         if(element.type == SharedMediaType.IMAGE)
  //         {
  //           imageList.add(File(element.path));
  //         }
  //         else
  //         {
  //           videoList.add(File(element.path));
  //         }
  //       });
  //     }
  //   else
  //     {
  //       //openGallery();
  //     }
  //   super.initState();
  // }

  openGallery() async {
    final List<XFile> images = await picker.pickMultiImage();

    images.forEach((element) {
      imageList.add(File(element.path));
    });

    setState(() {
      imagesSelected = true;
    });
  }

  pickVideo() async {
    final XFile video = await picker.pickVideo(source: ImageSource.gallery);

    videoList.add(File(video.path));

    setState(() {
      imagesSelected = true;
    });
  }

  // Future<void> getGalleryPhotos() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   var result = await PhotoManager.requestPermission();

  //   if (result) {
  //     bool isRecent = collectionName == "Recent";
  //     galleryItems = [];

  //     List<AssetPathEntity> list = await PhotoManager.getAssetPathList();

  //     var result = list.where((element) => element.name == collectionName).toList();

  //     setState(() {
  //       collections = list;
  //     });

  //     AssetPathEntity data = isRecent ? list[0] : result[0]; // 1st album in the list, typically the "Recent" or "All" album
  //     List<AssetEntity> imageList = await data.assetList;

  //     imageList.forEach((image) async {
  //       //AssetEntity entity = imageList[0];

  //       File file = await image.file; // image file

  //       galleryItems.add(file);
  //     });

  //     // if(loopCount == 0)
  //     //   {
  //     //     getGalleryPhotos().then((value) {
  //     //       setState(() {
  //     //         loopCount = loopCount + 1;
  //     //       });
  //     //     });
  //     //   }

  //   } else {
  //     Navigator.pop(context);
  //   }

  //   setState(() {
  //     loading = false;
  //   });

  // }

  displayGalleryImages() {
    Size size = MediaQuery.of(context).size;

    return GridView.count(
      crossAxisCount: 2,
      physics: BouncingScrollPhysics(),
      children: List.generate(galleryItems.length, (index) {
        File imageFile = galleryItems[index];
        bool isVideo = imageFile.path.split(".").last == "mp4";
        bool isSelected = fileLocations.contains(imageFile.path);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: isVideo
              ? InkWell(
                  //onLongPress: () {},
                  onTap: () {
                    if (isSelected) {
                      fileLocations
                          .removeWhere((element) => element == imageFile.path);
                      videoList.removeWhere(
                          (element) => element.path == imageFile.path);
                      setState(() {});
                    } else {
                      fileLocations.add(imageFile.path);
                      videoList.add(imageFile);
                      setState(() {});
                    }
                  },
                  child: VideoLayout(
                    file: imageFile,
                    isSelected: isSelected,
                  ))
              : InkWell(
                  //onLongPress: () {},
                  onTap: () {
                    if (isSelected) {
                      fileLocations
                          .removeWhere((element) => element == imageFile.path);
                      imageList.removeWhere(
                          (element) => element.path == imageFile.path);
                      setState(() {});
                    } else {
                      fileLocations.add(imageFile.path);
                      imageList.add(imageFile);
                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: size.width * 0.5,
                        decoration: BoxDecoration(
                            //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0),),
                            image: DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: isSelected
                            ? CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.black54,
                                child: Center(
                                    child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )))
                            : Text(""),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  deleteImage(int index, String fileType) {
    setState(() {
      loading = true;
    });

    uploadList = [];

    imageList.forEach((image) {
      uploadList.add(image);
    });

    videoList.forEach((video) {
      uploadList.add(video);
    });

    if (uploadList.length < 2) {
      Navigator.pop(context);
    } else {
      if (fileType == "image") {
        imageList.removeAt(index);
      } else if (fileType == "video") {
        videoList.removeAt(index);
      }
    }

    setState(() {
      loading = false;
    });
  }

  displayImages() {
    Size size = MediaQuery.of(context).size;

    if (imageList.length == 0 || imageList == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: openGallery,
            child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.grey, width: 1.5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                      child: Text(
                    "Add Photos",
                    style: TextStyle(color: Colors.grey),
                  )),
                )),
          ),
        ),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: size.height * 0.2, //180.0,
          child: loading
              ? circularProgress()
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: imageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          File image = imageList[index];

                          return AdditionalImage(
                              file: image,
                              onPressed: () => deleteImage(index, "image"));
                        },
                      ),
                      // AddImage(
                      //   onPressed: () => takeImage2(context, "image"),
                      //   iconData: Icons.add_a_photo_outlined,
                      // ),
                    ],
                  ),
                ));
    }
  }

  displayVideos() {
    Size size = MediaQuery.of(context).size;

    if (videoList.length == 0 || videoList == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: pickVideo,
            child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.grey, width: 1.5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                      child: Text(
                    "Add Video",
                    style: TextStyle(color: Colors.grey),
                  )),
                )),
          ),
        ),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: size.height * 0.2, //180.0,
          child: loading
              ? circularProgress()
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: videoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          File video = videoList[index];

                          return AdditionalVideo(
                              file: video,
                              onPressed: () => deleteImage(index, "video"));
                        },
                      ),
                      // AddImage(
                      //   onPressed: () => takeImage2(context, "video"),
                      //   iconData: Icons.video_call_outlined,
                      // ),
                    ],
                  ),
                ));
    }
  }

  clearPostInfo() {
    description.clear();
    location.clear();
    videoList.clear();
    imageList.clear();

    Navigator.pop(context);
  }

  uploadFiles(String postId) async {
    for (var file in uploadList) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = file.path.split(".").last;

      await FirebaseManager()
          .uploadPhoto(
        mImageFile: file,
        postId: postId,
        fileName: "${fileName}_$postId.$extension",
        folderName: "Feed",
        isMultiple: true,
      )
          .then((downloadUrl) {
        uploadUrls.add(downloadUrl.toString());
        if (uploadUrls.length == uploadList.length) {
          bool isMe = (GoTour.account.id == brian.id);

          feedReference.doc(postId).set({
            "urls": uploadUrls,
            "postId": postId,
            "comments": 0,
            "likes": 0,
            "share": 0,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "description": description.text.isEmpty ? "" : description.text,
            "location": location.text.isEmpty ? "" : location.text,
            "username": isMe ? mickey.username : GoTour.account.username,
            "publisherID": isMe ? mickey.id : GoTour.account.id,
            "ownerUrl": isMe ? mickey.url : GoTour.account.url,
          }).then((_) async {
            String userId = isMe ? mickey.id : GoTour.account.id;

            await usersReference.doc(userId).get().then((value) {
              if (!value.data().containsKey("feedPosts")) {
                value.reference.set({
                  "feedPosts": 1,
                }, SetOptions(merge: true));
              } else {
                value.reference.update({
                  "feedPosts": value.data()["feedPosts"] + 1,
                });
              }
            });
            Fluttertoast.showToast(msg: "Post Uploaded Successfully");

            setState(() {
              // videoList = [];
              // videoUrls = [];
            });
          });
        }
      });
    }
  }

  controlUploadAndSave() async {
    setState(() {
      loading = true;
    });

    uploadList = [];

    imageList.forEach((image) {
      uploadList.add(image);
    });

    videoList.forEach((video) {
      uploadList.add(video);
    });

    await uploadFiles(postId);

    Navigator.pop(context);
  }

  uploadFormScreen(width) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "New Post",
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: clearPostInfo,
        ),
      ),
      body: loading
          ? circularProgress()
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  displayImages(),
                  displayVideos(),
                  CustomField(
                      controller: description,
                      hintText: "Type something...",
                      width: width,
                      isDigits: false,
                      widget: null),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomField(
                      controller: location,
                      hintText: "Location(Optional)",
                      width: width,
                      isDigits: false,
                      widget: null),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0)),
                        color: Colors.teal,
                        onPressed:
                            loading ? null : () => controlUploadAndSave(),
                        child: Text(
                          "Share",
                          style: GoogleFonts.fredokaOne(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
    );
  }

  choiceAction(String choice) {
    setState(() {
      collectionName = choice;
      loopCount = 0;
    });

    // getGalleryPhotos().then((value) {
    //   setState(() {

    //   });
    // });
  }

  feedHomeScreen() {
    Color color = Theme.of(context).scaffoldBackgroundColor;
    Color textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Upload Feed",
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // actions: [
          //   PopupMenuButton<String>(
          //     icon: Icon(Icons.sort, color: textColor, size: 25.0,),
          //     offset: Offset(0.0, 0.0),
          //     onSelected: choiceAction,
          //     itemBuilder: (BuildContext context){
          //
          //       return List.generate(collections.length, (index) {
          //         String choice = collections[index].name;
          //
          //         return PopupMenuItem<String>(
          //           value: choice,
          //           child: Text(choice),
          //         );
          //       });
          //
          //       // return PostType.types.map((String choice){
          //       //   return PopupMenuItem<String>(
          //       //     value: choice,
          //       //     child: Text(choice),
          //       //   );
          //       // }).toList();
          //     },
          //   )
          // ],
          // bottom: PreferredSize(
          //   preferredSize: Size(size.width, 40.0),
          //   child: Container(
          //     height: 40.0,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Container(
          //             width: size.width *0.7,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Icon(Icons.list, color: Colors.grey,),
          //                 SizedBox(width: 10.0,),
          //                 Text(collectionName.trimRight(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold),)
          //               ],
          //             ),
          //           ),
          //           (imageList+videoList).length > 0 ?RaisedButton.icon(
          //             color: Colors.teal,
          //             onPressed: () {
          //               setState(() {
          //                 imagesSelected = true;
          //               });
          //             },
          //             label: Text("Next", style: GoogleFonts.fredokaOne(color: Colors.white),),
          //             icon: Icon(Icons.navigate_next_rounded, color: Colors.white,),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20.0)
          //             ),
          //           ) : Text("")
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
        body: loading
            ? circularProgress()
            : Column(
                children: [
                  ListTile(
                    onTap: openGallery,
                    leading: Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                    title: Text("Pick Images"),
                  ),
                  ListTile(
                    onTap: pickVideo,
                    leading: Icon(
                      Icons.video_collection_outlined,
                      color: Colors.grey,
                    ),
                    title: Text("Pick Video"),
                  ),
                ],
              ) //displayGalleryImages(),
        );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return imagesSelected ? uploadFormScreen(width) : feedHomeScreen();

    // if (widget.sharedFiles.length > 0) {
    //   return uploadFormScreen(width);
    // } else {
    //   return imagesSelected
    //       ? uploadFormScreen(width)
    //       : RefreshIndicator(
    //           child: feedHomeScreen(), onRefresh: getGalleryPhotos);
    // }
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoLayout extends StatefulWidget {
  final File file;
  final bool isSelected;

  const VideoLayout({Key key, this.file, this.isSelected}) : super(key: key);

  @override
  _VideoLayoutState createState() => _VideoLayoutState();
}

class _VideoLayoutState extends State<VideoLayout> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});

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

    if (size < 1000) {
      return size.toString() + " B";
    } else if (size >= 1000 && size < 1000000) {
      size = (size / 1000).round();
      return size.toString() + " KB";
    } else if (size >= 1000000) {
      size = (size / 1000000).round();
      return size.toString() + " MB";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            //borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ClipRRect(
            //borderRadius: BorderRadius.circular(20.0),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: widget.isSelected
              ? CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.black54,
                  child: Center(
                      child: Icon(
                    Icons.check,
                    color: Colors.white,
                  )))
              : Text(""),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            height: 40.0,
            color: Colors.black54,
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
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(30.0)),
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown
                  // setState(() {
                  //   // If the video is playing, pause it.
                  //   if (_controller.value.isPlaying) {
                  //     _controller.pause();
                  //   } else {
                  //     // If the video is paused, play it.
                  //     _controller.play();
                  //   }
                  // });
                },
                // Display the correct icon depending on the state of the player.
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.video_collection_outlined
                      : Icons.video_collection_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: Text(
            fileSize(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
