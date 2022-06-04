// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

import '../main.dart';
import 'home.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File file;
  final picker = ImagePicker();
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  Account user;
  bool loading = false;
  bool _phoneValid = true;
  bool _profileNameValid = true;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    getAndDisplayUserInfo();
  }

  Future getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot =
        await usersReference.doc(GoTour.account.id).get();

    user = Account.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;

    phoneTextEditingController.text = user.phone;

    setState(() {
      loading = false;
    });
  }

  createProfileNameTextFormField() {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Profile Name",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        TextField(
          style: TextStyle(color: isBright ? Colors.black : Colors.white),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
              hintText: "Write Profile Name here...",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.grey),
              errorText:
                  _profileNameValid ? null : "Profile Name is very short"),
        )
      ],
    );
  }

  createBioTextFormField() {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Phone",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        TextField(
          style: TextStyle(color: isBright ? Colors.black : Colors.white),
          controller: phoneTextEditingController,
          decoration: InputDecoration(
              hintText: "Write phone number here...",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _phoneValid ? null : "Phone number is very long"),
        )
      ],
    );
  }

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

  showOptions(myContext) {
    return showDialog(
      context: myContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Change Photo",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
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

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_${GoTour.account.id}.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 80));
    setState(() {
      file = compressedImageFile;
    });
  }

  updateUserData() async {
    setState(() {
      loading = true;
    });

    if (file == null) {
      setState(() {
        profileNameTextEditingController.text.trim().length < 3 ||
                profileNameTextEditingController.text.isEmpty
            ? _profileNameValid = false
            : _profileNameValid = true;

        phoneTextEditingController.text.trim().length > 15
            ? _phoneValid = false
            : _phoneValid = true;
      });

      if (_phoneValid && _profileNameValid) {
        if (isSelected) {
          usersReference.doc(GoTour.account.id).update({
            "profileName": profileNameTextEditingController.text,
            "phone": phoneTextEditingController.text,
            "role": "Seller"
          });
        } else {
          usersReference.doc(GoTour.account.id).update({
            "profileName": profileNameTextEditingController.text,
            "phone": phoneTextEditingController.text,
          });
        }
      }
    } else {
      await compressingPhoto();

      String downloadUrl = await FirebaseManager().uploadPhoto(
        mImageFile: file,
        postId: "",
        fileName: "post_${GoTour.account.id}.jpg",
        folderName: "Profile Photos",
        isMultiple: false,
      );

      setState(() {
        profileNameTextEditingController.text.trim().length < 3 ||
                profileNameTextEditingController.text.isEmpty
            ? _profileNameValid = false
            : _profileNameValid = true;

        phoneTextEditingController.text.trim().length > 15
            ? _phoneValid = false
            : _phoneValid = true;
      });

      if (_phoneValid && _profileNameValid) {
        if (isSelected) {
          usersReference.doc(GoTour.account.id).update({
            "profileName": profileNameTextEditingController.text,
            "phone": phoneTextEditingController.text,
            "url": downloadUrl,
            "role": "Seller"
          });
        } else {
          usersReference.doc(GoTour.account.id).update({
            "profileName": profileNameTextEditingController.text,
            "phone": phoneTextEditingController.text,
            "url": downloadUrl,
          });
        }
      }
    }

    Fluttertoast.showToast(
        msg: "Profile has been updated successfully. Relaunch Application",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.4));

    setState(() {
      file = null;
      loading = false;
    });

    Route route = MaterialPageRoute(builder: (context) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.transparent,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        titleSpacing: 1.2,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.teal,
              size: 30.0,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: loading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
                        child: CircleAvatar(
                          radius: 52.0,
                          backgroundColor: Colors.grey,
                          //backgroundImage: AssetImage('assets/images/profile.png'),
                          backgroundImage: file == null
                              ? NetworkImage(user.url)
                              : FileImage(file), //TODO:
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () => showOptions(context),
                          child: const Text(
                            "Change Profile photo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            createProfileNameTextFormField(),
                            createBioTextFormField(),
                            user.role == "Buyer"
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ListTile(
                                        leading: Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.teal,
                                          value: isSelected, //this.valuefirst,
                                          onChanged: (bool value) {
                                            setState(() {
                                              isSelected = value;
                                              //this.valuefirst = value;
                                            });
                                          },
                                        ),
                                        title: Text(
                                          "Want to advertise hotels, adventures, rent a house or sell land",
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        )),
                                  )
                                : Text("")
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 29.0, left: 80.0, right: 80.0),
                        child: RaisedButton(
                          elevation: 10.0,
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.0)),
                          onPressed: updateUserData,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              Text(
                                "  Update  ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
