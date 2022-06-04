import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/DialogBox/errorDialog.dart';
import 'package:gotour/DialogBox/loadingDialog.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/firebaseManager/image_manager.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/about.dart';
import 'package:gotour/pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  Uint8List file;
  final picker = ImagePicker();
  User currentUser;
  String role;
  bool showPassword = false;

  Future<void> uploadAndSaveImage() async {
    if (file == null) {
      displayDialog("Please Pick Profile Photo");
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty &&
                  _username.text.isNotEmpty &&
                  _phone.text.isNotEmpty &&
                  _name.text.isNotEmpty &&
                  role != null
              ? uploadToStorage()
              : displayDialog("Write the required registration form")
          : displayDialog("Password does not match");
    }
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: 'Registering, Please wait...',
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    userImageUrl = await FileManager().uploadPhoto(file, "$imageFileName.jpg");

    // userImageUrl = await FirebaseManager().uploadPhoto(
    //   mImageFile: file,
    //   postId: "",
    //   fileName: "$imageFileName.jpg",
    //   folderName: "Profile Photos",
    //   isMultiple: false,
    // );

    _registerUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      if (role == "Seller") {
        Route route = MaterialPageRoute(
            builder: (context) => TermsAndConditions(
                  isVisible: false,
                ));
        await Navigator.push(context, route);
      }

      saveUserToFireStore(firebaseUser).then((value) async {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserToFireStore(User fUser) async {
    await usersReference.doc(fUser.uid).set({
      "id": fUser.uid,
      "profileName": _name.text.trim(),
      "username": _username.text.trim(),
      "url": userImageUrl,
      "email": fUser.email,
      "timestamp": timestamp,
      "phone": _phone.text.trim(),
      "role": role,
      "followers": 0,
      "following": 0,
      "posts": 0,
      "deviceTokens": []
    });

    await usersReference.doc(fUser.uid).get().then((dataSnapshot) {
      setState(() {
        GoTour.account = Account.fromDocument(dataSnapshot);
      });
    });
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  // Future captureImageWithCamera() async {
  //   Navigator.pop(context);
  //   PickedFile imageFile = await picker.getImage(
  //     source: ImageSource.camera,
  //     maxHeight: 680,
  //     maxWidth: 970,
  //   );
  //   setState(() {
  //     this.file = File(imageFile.path);
  //   });
  // }

  Future pickImageFromGallery() async {
    Navigator.pop(context);
    // PickedFile imageFile = await picker.getImage(
    //   source: ImageSource.gallery,
    //   maxHeight: 680,
    //   maxWidth: 970,
    // );
    Uint8List image = FileManager().pickSingleImage();

    setState(() {
      file = image;
    });
  }

  showOptions(myContext) {
    return showDialog(
      context: myContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Pick Photo",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              color: Colors.teal,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text(
                "Capture Image with Camera",
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Select Image from Gallery",
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  onChanged(String value) {
    setState(() {
      role = value;
    });
    print(role);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MobileViewRegister(
        file: file,
        pickPhoto: () => showOptions(context),
        role: role,
        username: _username,
        name: _name,
        phone: _phone,
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        cPasswordTextEditingController: _cPasswordTextEditingController,
        onChanged: onChanged,
        uploadAndSaveImage: () => uploadAndSaveImage(),
      ),
      tablet: MobileViewRegister(
        file: file,
        pickPhoto: () => showOptions(context),
        role: role,
        username: _username,
        name: _name,
        phone: _phone,
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        cPasswordTextEditingController: _cPasswordTextEditingController,
        onChanged: onChanged,
        uploadAndSaveImage: () => uploadAndSaveImage(),
      ),
      desktop: DesktopViewRegister(
        file: file,
        pickPhoto: () => showOptions(context),
        role: role,
        username: _username,
        name: _name,
        phone: _phone,
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        cPasswordTextEditingController: _cPasswordTextEditingController,
        onChanged: onChanged,
        uploadAndSaveImage: () => uploadAndSaveImage(),
      ),
      watch: Container(),
    );
  }
}

class DesktopViewRegister extends StatefulWidget {
  final Uint8List file;
  final Function pickPhoto;
  final String role;
  final TextEditingController username;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final TextEditingController cPasswordTextEditingController;
  final void Function(String) onChanged;
  final Function uploadAndSaveImage;

  const DesktopViewRegister(
      {Key key,
      this.file,
      this.pickPhoto,
      this.role,
      this.username,
      this.name,
      this.phone,
      this.emailTextEditingController,
      this.passwordTextEditingController,
      this.cPasswordTextEditingController,
      this.onChanged,
      this.uploadAndSaveImage})
      : super(key: key);

  @override
  _DesktopViewRegisterState createState() => _DesktopViewRegisterState();
}

class _DesktopViewRegisterState extends State<DesktopViewRegister> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              //color: Colors.teal.shade200,
              height: _screenHeight,
              decoration: const BoxDecoration(
                  color: Colors.black26,
                  image: DecorationImage(
                      image: AssetImage("assets/images/login.jpg"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: GoogleFonts.fredokaOne(
                        color: Colors.teal, fontSize: _screenWidth * 0.03),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Hero(
                    tag: "assets/images/testlogo2.png",
                    child: Container(
                      //width: 60.0, height: 35.0,
                      // width: 90.0,
                      // height: 90.0,
                      width: _screenHeight * 0.20,
                      height: _screenHeight * 0.20,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/testlogo2.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: _screenHeight * 0.1,
                    ),
                    // Text(
                    //   "Register",
                    //   style: GoogleFonts.fredokaOne(
                    //       color: Colors.teal, fontSize: _screenWidth * 0.08),
                    // ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
                      child: CircleAvatar(
                        radius: 52.0,
                        backgroundImage: widget.file == null
                            ? const AssetImage("assets/images/profile.png")
                            : MemoryImage(widget.file),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: widget.pickPhoto,
                        child: Text(
                          "Pick Profile Photo",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredokaOne(
                            color: Colors.teal,
                            //fontSize: 15.0
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Column(
                      children: [
                        CustomTextField(
                          controller: widget.username,
                          data: Icons.alternate_email_rounded,
                          hintText: "Username",
                          isObscure: false,
                        ),
                        CustomTextField(
                          controller: widget.name,
                          data: Icons.person,
                          hintText: "Name",
                          isObscure: false,
                        ),
                        CustomTextField(
                          controller: widget.phone,
                          data: Icons.phone_android,
                          hintText: "Phone Number",
                          isObscure: false,
                        ),
                        CustomTextField(
                          controller: widget.emailTextEditingController,
                          data: Icons.email_outlined,
                          hintText: "Email",
                          isObscure: false,
                        ),
                        CustomTextField(
                          controller: widget.passwordTextEditingController,
                          data: Icons.lock_outlined,
                          hintText: "Password",
                          isObscure: showPassword ? false : true,
                        ),
                        CustomTextField(
                          controller: widget.cPasswordTextEditingController,
                          data: Icons.lock_outline,
                          hintText: "Confirm Password",
                          isObscure: showPassword ? false : true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.teal,
                              value: showPassword,
                              onChanged: (bool value) {
                                setState(() {
                                  showPassword = value;
                                });
                              },
                            ),
                            const Text("Show Password")
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "What's your Role?",
                          style: GoogleFonts.fredokaOne(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        RadioListTile<String>(
                          title: const Text(
                              "Looking to have fun, travel and adventures, buy or rent a house"),
                          value: "Buyer",
                          groupValue: widget.role,
                          onChanged: widget.onChanged,
                        ),
                        RadioListTile<String>(
                          title: const Text(
                              "Looking to advertise hotels, adventures, rent a house or sell land"),
                          value: "Seller",
                          groupValue: widget.role,
                          onChanged: widget.onChanged,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                    Container(
                      height: 50.0,
                      width: 120.0,
                      child: RaisedButton(
                        onPressed: widget.uploadAndSaveImage,
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Register",
                          style: GoogleFonts.fredokaOne(
                            color: Colors.white,
                          ),
                        ),
                        elevation: 5.0,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      height: 4.0,
                      width: _screenWidth * 0.4,
                      color: Colors.teal,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Already have an Account?",
                          style: TextStyle(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => Login());
                              Navigator.pushReplacement(context, route);
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.fredokaOne(color: Colors.teal),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileViewRegister extends StatefulWidget {
  final Uint8List file;
  final Function pickPhoto;
  final String role;
  final TextEditingController username;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final TextEditingController cPasswordTextEditingController;
  final void Function(String) onChanged;
  final Function uploadAndSaveImage;

  const MobileViewRegister(
      {Key key,
      this.file,
      this.pickPhoto,
      this.role,
      this.username,
      this.name,
      this.phone,
      this.emailTextEditingController,
      this.passwordTextEditingController,
      this.cPasswordTextEditingController,
      this.onChanged,
      this.uploadAndSaveImage})
      : super(key: key);

  @override
  _MobileViewRegisterState createState() => _MobileViewRegisterState();
}

class _MobileViewRegisterState extends State<MobileViewRegister> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: _screenHeight * 0.1,
              ),
              Text(
                "Register",
                style: GoogleFonts.fredokaOne(
                    color: Colors.teal, fontSize: _screenWidth * 0.08),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
                child: CircleAvatar(
                  radius: 52.0,
                  backgroundImage: widget.file == null
                      ? const AssetImage("assets/images/profile.png")
                      : MemoryImage(widget.file),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: widget.pickPhoto,
                  child: Text(
                    "Pick Profile Photo",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredokaOne(
                      color: Colors.teal,
                      //fontSize: 15.0
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Column(
                children: [
                  CustomTextField(
                    controller: widget.username,
                    data: Icons.alternate_email_rounded,
                    hintText: "Username",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: widget.name,
                    data: Icons.person,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: widget.phone,
                    data: Icons.phone_android,
                    hintText: "Phone Number",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: widget.emailTextEditingController,
                    data: Icons.email_outlined,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: widget.passwordTextEditingController,
                    data: Icons.lock_outlined,
                    hintText: "Password",
                    isObscure: showPassword ? false : true,
                  ),
                  CustomTextField(
                    controller: widget.cPasswordTextEditingController,
                    data: Icons.lock_outline,
                    hintText: "Confirm Password",
                    isObscure: showPassword ? false : true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.teal,
                        value: showPassword,
                        onChanged: (bool value) {
                          setState(() {
                            showPassword = value;
                          });
                        },
                      ),
                      const Text("Show Password")
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "What's your Role?",
                    style: GoogleFonts.fredokaOne(),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  RadioListTile<String>(
                    title: const Text(
                        "Looking to have fun, travel and adventures, buy or rent a house"),
                    value: "Buyer",
                    groupValue: widget.role,
                    onChanged: widget.onChanged,
                  ),
                  RadioListTile<String>(
                    title: const Text(
                        "Looking to advertise hotels, adventures, rent a house or sell land"),
                    value: "Seller",
                    groupValue: widget.role,
                    onChanged: widget.onChanged,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
              Container(
                height: 50.0,
                width: 120.0,
                child: RaisedButton(
                  onPressed: widget.uploadAndSaveImage,
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    "Register",
                    style: GoogleFonts.fredokaOne(
                      color: Colors.white,
                    ),
                  ),
                  elevation: 5.0,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 4.0,
                width: _screenWidth * 0.8,
                color: Colors.teal,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Already have an Account?",
                    style: TextStyle(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (context) => Login());
                        Navigator.pushReplacement(context, route);
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.fredokaOne(color: Colors.teal),
                      )),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObscure = true;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // color: Colors.grey.withOpacity(0.3),
          // borderRadius: BorderRadius.circular(30.0),
          ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                width: 1.0,
              )),
          prefixIcon: Icon(
            data,
            color: Colors.grey[400],
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
