// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/pages/home.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/additionalImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class UploadCarousel extends StatefulWidget {
  //final List<SharedMediaFile> sharedFiles;

  const UploadCarousel({
    Key key,
  }) : super(key: key);

  @override
  _UploadCarouselState createState() => _UploadCarouselState();
}

class _UploadCarouselState extends State<UploadCarousel>
    with AutomaticKeepAliveClientMixin<UploadCarousel> {
  File file2;
  final picker = ImagePicker();
  bool uploading = false;
  List<File> imageList = <File>[];
  List<String> imageUrls = <String>[];
  String postId = Uuid().v4();

  // @override
  // void initState() {
  //   super.initState();

  //   checkForFiles();
  // }

  // checkForFiles() async {
  //   if (widget.sharedFiles.length > 0) {
  //     widget.sharedFiles.forEach((element) {
  //       if (element.type == SharedMediaType.IMAGE) {
  //         imageList.add(File(element.path));
  //       }
  //     });
  //   }
  // }

  Future captureImageWithCamera2() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file2 = File(imageFile.path);
    });

    imageList.add(file2);

    setState(() {
      file2 = null;
    });
  }

  Future pickImageFromGallery2() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file2 = File(imageFile.path);
    });

    imageList.add(file2);

    setState(() {
      file2 = null;
    });
  }

  takeImage2(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "New Post",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF3EBACE), fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Capture Image with Camera"),
              onPressed: captureImageWithCamera2,
            ),
            SimpleDialogOption(
              child: Text("Select Image from Gallery"),
              onPressed: pickImageFromGallery2,
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  clearPostInfo() {
    imageList.clear();
  }

  void uploadImages() async {
    setState(() {
      uploading = true;
    });

    for (var imageFile in imageList) {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = "${time}_$postId.jpg";
      await compressingPhoto2(imageFile);
      FirebaseManager()
          .uploadPhoto(
              mImageFile: imageFile,
              postId: postId,
              fileName: fileName,
              folderName: "Carousel Pictures",
              isMultiple: true)
          .then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == imageList.length) {
          carouselReference.doc(postId).set({
            'urls': imageUrls,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          }).then((_) {
            Fluttertoast.showToast(
                msg: "Post Uploaded Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black.withOpacity(0.4));
            setState(() {
              imageList = [];
              imageUrls = [];
              uploading = false;
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  deleteImage(int index) {
    setState(() {
      uploading = true;
    });

    imageList.removeAt(index);

    setState(() {
      uploading = false;
    });
  }

  // Future<String> uploadPhoto2(mImageFile) async {
  //   StorageUploadTask mStorageUploadTask = carouselStorageReference.child().putFile(mImageFile);
  //   StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
  //   String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  compressingPhoto2(mFile) async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(mFile.readAsBytesSync());
    final compressedImageFile = File('$path/img2_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      mFile = compressedImageFile;
    });
  }

  Widget displayGrid() {
    return Flexible(
      fit: FlexFit.loose,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(imageList.length, (index) {
          File image = imageList[index];

          return AdditionalImage(
              file: image, onPressed: () => deleteImage(index));
        }),
      ),
    );
  }

  displayUploadScreen() {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          title: Text(
            "Carousel",
            style: TextStyle(color: Color(0xFF3EBACE)),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios), onPressed: clearPostInfo),
        ),
        body: uploading
            ? circularProgress()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //width: 250.0,
                          height: 60.0,
                          alignment: Alignment.center,
                          child: RaisedButton.icon(
                            elevation: 5.0,
                            onPressed: () => takeImage2(context),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0)),
                            color: Color(0xFF3EBACE),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          //width: 250.0,
                          height: 60.0,
                          alignment: Alignment.center,
                          child: RaisedButton.icon(
                            elevation: 5.0,
                            onPressed: uploadImages,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0)),
                            color: Color(0xFF3EBACE),
                            icon: Icon(
                              Icons.cloud_upload_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Upload",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    displayGrid(),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ));
  }

  displayStart() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Carousel",
          style: TextStyle(color: Color(0xFF3EBACE)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add_photo_alternate,
                color: Colors.grey,
                size: 100.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "Upload Image",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Color(0xFF3EBACE),
                    onPressed: () => takeImage2(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageList == null || imageList.length == 0
        ? displayStart()
        : displayUploadScreen();
  }

  @override
  bool get wantKeepAlive => true;
}
