import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Auth/register.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/DialogBox/errorDialog.dart';
import 'package:gotour/DialogBox/loadingDialog.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/home.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Account currentUser;
  bool showPassword = false;

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingAlertDialog(
            message: "Authenticating. Please wait...",
          );
        });
    User firebaseUser;

    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUser) async {
    await usersReference.doc(fUser.uid).get().then((dataSnapshot) async {
      setState(() {
        GoTour.account = Account.fromDocument(dataSnapshot);
      });
    });
  }

  onPressed() {
    _emailTextEditingController.text.isNotEmpty &&
            _passwordTextEditingController.text.isNotEmpty
        ? loginUser()
        : showDialog(
            context: context,
            builder: (c) {
              return const ErrorAlertDialog(
                message: "Please write email and password",
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return ScreenTypeLayout(
      mobile: MobileViewLogin(
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        onPressed: () => onPressed(),
      ),
      tablet: MobileViewLogin(
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        onPressed: () => onPressed(),
      ),
      desktop: DeskTopViewLogin(
        emailTextEditingController: _emailTextEditingController,
        passwordTextEditingController: _passwordTextEditingController,
        onPressed: () => onPressed(),
      ),
      watch: Container(),
    );
  }
}

class MobileViewLogin extends StatefulWidget {
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final Function onPressed;

  const MobileViewLogin(
      {Key key,
      this.emailTextEditingController,
      this.passwordTextEditingController,
      this.onPressed})
      : super(key: key);

  @override
  State<MobileViewLogin> createState() => _MobileViewLoginState();
}

class _MobileViewLoginState extends State<MobileViewLogin> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: _screenHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.fredokaOne(
                        color: Colors.teal, fontSize: _screenWidth * 0.08),
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
                      width: _screenWidth * 0.20,
                      height: _screenWidth * 0.20,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/testlogo2.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Login to your Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: [
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
                    ],
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
                  Container(
                    height: 50.0,
                    width: 120.0,
                    child: RaisedButton(
                      onPressed: widget.onPressed,
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text(
                        "Login",
                        style: GoogleFonts.fredokaOne(
                          color: Colors.white,
                        ),
                      ),
                      elevation: 5.0,
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.8,
                    color: Colors.teal,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Don't have an Account?",
                        style: TextStyle(
                            //fontSize: _screenWidth * 0.04//17.0
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => Register());
                            Navigator.pushReplacement(context, route);
                          },
                          child: Text(
                            "Register",
                            style: GoogleFonts.fredokaOne(color: Colors.teal),
                          )),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class DeskTopViewLogin extends StatefulWidget {
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final Function onPressed;

  const DeskTopViewLogin(
      {Key key,
      this.emailTextEditingController,
      this.passwordTextEditingController,
      this.onPressed})
      : super(key: key);

  @override
  _DeskTopViewLoginState createState() => _DeskTopViewLoginState();
}

class _DeskTopViewLoginState extends State<DeskTopViewLogin> {
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
                    "Login",
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
            child: Container(
              height: _screenHeight,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Login to your Account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
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
                      ],
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
                    Container(
                      height: 50.0,
                      width: 120.0,
                      child: RaisedButton(
                        onPressed: widget.onPressed,
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Login",
                          style: GoogleFonts.fredokaOne(
                            color: Colors.white,
                          ),
                        ),
                        elevation: 5.0,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      height: 4.0,
                      width: _screenWidth * 0.4,
                      color: Colors.teal,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(
                              //fontSize: _screenWidth * 0.04//17.0
                              ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => Register());
                              Navigator.pushReplacement(context, route);
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.fredokaOne(color: Colors.teal),
                            )),
                      ],
                    )
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
