// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

final lmStorageReference = FirebaseStorage.instance.ref().child("Landmarks");
final landmarkReference = FirebaseFirestore.instance.collection("landmarks");

class UploadLandmark extends StatefulWidget {
  //final List<SharedMediaFile> sharedFiles;

  const UploadLandmark({
    Key key,
  }) : super(key: key);

  @override
  _UploadLandmarkState createState() => _UploadLandmarkState();
}

class _UploadLandmarkState extends State<UploadLandmark>
    with AutomaticKeepAliveClientMixin<UploadLandmark> {
  File file;
  final picker = ImagePicker();
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _locationCityTextEditingController =
      TextEditingController();
  TextEditingController _localityTextEditingController =
      TextEditingController();
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   checkForFiles();
  // }

  // checkForFiles() async {
  //   if(widget.sharedFiles.length > 0)
  //   {
  //     setState(() {
  //       file = File(widget.sharedFiles[0].path);
  //     });
  //   }
  // }

  Future captureImageWithCamera() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = File(imageFile.path);
    });
  }

  Future pickImageFromGallery() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = File(imageFile.path);
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "New Post",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF3EBACE), fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Capture Image with Camera",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                "Select Image from Gallery",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  clearPostInfo() {
    _locationCityTextEditingController.clear();
    _latitude.clear();
    _longitude.clear();
    _nameTextEditingController.clear();
    _localityTextEditingController.clear();

    setState(() {
      file = null;
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 80));
    setState(() {
      file = compressedImageFile;
    });
  }

  // Future<String> uploadPhoto(mImageFile) async {
  //   StorageUploadTask mStorageUploadTask = lmStorageReference.child().putFile(mImageFile);
  //   StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
  //   String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressingPhoto();

    String downloadUrl = await FirebaseManager().uploadPhoto(
        mImageFile: file,
        postId: postId,
        fileName: "post_$postId.jpg",
        folderName: "Landmarks",
        isMultiple: false);

    savePostInfoToFireStore(
      url: downloadUrl,
      locality: _localityTextEditingController.text.trim(),
      city: _locationCityTextEditingController.text.trim(),
      latitude: double.parse(_latitude.text.trim()),
      longitude: double.parse(_longitude.text.trim()),
      name: _nameTextEditingController.text.trim(),
    );

    _nameTextEditingController.clear();
    _locationCityTextEditingController.clear();
    _latitude.clear();
    _longitude.clear();
    _localityTextEditingController.clear();

    Fluttertoast.showToast(
        msg: "Image Uploaded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.4));

    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostInfoToFireStore({
    String url,
    String name,
    String locality,
    String city,
    double latitude,
    double longitude,
  }) {
    landmarkReference.doc(postId).set({
      "postId": postId,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "name": name,
      "url": url,
      "locality": locality,
      "city": city,
      "latitude": latitude,
      "longitude": longitude
    });
  }

  displayUploadFormScreen() {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "New Locality",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 5.0,
              width: 5.0,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Center(
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: clearPostInfo))),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: RaisedButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0)),
              color: Colors.black.withOpacity(0.5),
              onPressed: uploading ? null : () => controlUploadAndSave(),
              child: Text(
                "Share",
                style: TextStyle(
                    color: Color(0xFF3EBACE),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width, //* 0.8,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                        image: DecorationImage(
                          image: FileImage(file),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: uploading
                  ? circularProgress()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomField(
                                controller: _nameTextEditingController,
                                hintText: "Name",
                                width: width,
                                isDigits: false,
                                widget: null),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomField(
                                controller: _localityTextEditingController,
                                hintText: "Locality",
                                width: width,
                                isDigits: false,
                                widget: null),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomField(
                                controller: _locationCityTextEditingController,
                                hintText: "City",
                                width: width,
                                isDigits: false,
                                widget: null),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomField(
                                controller: _latitude,
                                hintText: "Latitude",
                                width: width,
                                isDigits: false,
                                widget: null),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomField(
                                controller: _longitude,
                                hintText: "Longitude",
                                width: width,
                                isDigits: false,
                                widget: null),
                          ],
                        ),
                      ),
                    )),
        ],
      ),
    );
  }

  displayUploadScreen() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: () => takeImage(context)),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
