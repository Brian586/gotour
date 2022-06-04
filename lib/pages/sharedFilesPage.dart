// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/firebaseManager/FirebaseManager.dart';
import 'package:gotour/models/Period.dart';
import 'package:gotour/models/PostType.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/additionalImage.dart';
import 'package:gotour/widgets/customTextField.dart';
import 'package:uuid/uuid.dart';

import 'editLocation.dart';
import 'home.dart';

class SharedFilesPage extends StatefulWidget {
  //final List<SharedMediaFile> sharedFiles;

  const SharedFilesPage({
    Key key,
  }) : super(key: key);

  @override
  _SharedFilesPageState createState() => _SharedFilesPageState();
}

class _SharedFilesPageState extends State<SharedFilesPage>
    with AutomaticKeepAliveClientMixin<SharedFilesPage> {
  bool loading = false;
  String postId = Uuid().v4();
  //final _formKey = GlobalKey<FormState>();
  String city;
  String country;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController typeTextEditingController = TextEditingController();
  TextEditingController localityTextEditingController = TextEditingController();
  TextEditingController currencyTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController payPeriodTextEditingController =
      TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  double latitude;
  double longitude;
  List<File> imageList = <File>[];
  List<File> videoList = <File>[];
  List<String> imageUrls = <String>[];
  List<String> videoUrls = <String>[];
  List<String> localities = <String>[];
  ScrollController _scrollController;
  List<String> imageFileNames = <String>[];
  List<String> videoFileNames = <String>[];
  bool lastStatus = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // widget.sharedFiles.forEach((element) {
    //   if (element.type == SharedMediaType.IMAGE) {
    //     imageList.add(File(element.path));
    //   } else {
    //     videoList.add(File(element.path));
    //   }
    // });

    if (imageList.length == 0) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Add a cover photo");
    }

    _determinePosition();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  _determinePosition() async {
    setState(() {
      loading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg:
                'Location permissions are permantly denied, we cannot request permissions.');

        Navigator.pop(context);

        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      } else if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          print('Location permissions are denied (actual value: $permission).');

          //_determinePosition();

          Fluttertoast.showToast(
              msg:
                  'Location permissions are denied (actual value: $permission).');

          Navigator.pop(context);
        }
      } else {
        await getLocationName();
      }
    } else {
      await getLocationName();
    }
  }

  getLocationName() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo =
        '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, '
        '${mPlaceMark.subLocality} ${mPlaceMark.locality}, '
        '${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, '
        '${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    String cityAddress = '${mPlaceMark.locality}';
    String countryAddress = '${mPlaceMark.country}';

    await getLocalities(cityAddress, countryAddress);

    if (localities.length == 0) {
      localities.add(city);

      await FirebaseFirestore.instance
          .collection("suggestions")
          .doc(postId)
          .set({
        "suggestion": "$city, $country",
        "username": GoTour.account.username,
        "timestamp": DateTime.now().millisecondsSinceEpoch
      });
    }

    print(specificAddress);

    setState(() {
      loading = false;
      city = cityAddress;
      country = countryAddress;
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  getLocalities(String cty, String contry) async {
    await destinationsReference
        .where("country", isEqualTo: contry)
        .where("city", isEqualTo: cty)
        .orderBy("timestamp", descending: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        await destinationsReference
            .doc(document.get("postId"))
            .collection("localities")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            localities = [];
            element.get("list").forEach((locality) {
              localities.add(locality);
            });
          });
        });
      });
    });
  }

  void periodAction(String choice) {
    setState(() {
      payPeriodTextEditingController.text = choice;
    });
  }

  deleteImage(int index, String fileType) {
    setState(() {
      loading = true;
    });

    if (fileType == "image") {
      if (imageList.length == 1) {
        Navigator.pop(context);
      } else {
        imageList.removeAt(index);
      }
    } else if (fileType == "video") {
      videoList.removeAt(index);
    }

    setState(() {
      loading = false;
    });
  }

  displayImages() {
    Size size = MediaQuery.of(context).size;

    if (imageList.length == 0 || imageList == null) {
      return Text("");
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
      return Text("");
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
    descriptionTextEditingController.clear();
    nameTextEditingController.clear();
    typeTextEditingController.clear();
    localityTextEditingController.clear();
    currencyTextEditingController.clear();
    priceTextEditingController.clear();
    payPeriodTextEditingController.clear();
    addressTextEditingController.clear();
    videoList.clear();
    imageList.clear();

    Navigator.pop(context);
  }

  editLocation() async {
    String locationInfo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditLocation()));

    if (locationInfo != "") {
      List<String> locationDetails = locationInfo.split(",");

      List<Location> locations = await locationFromAddress(
          "${locationDetails[0]}, ${locationDetails[1]}");

      localities.clear();

      setState(() {
        city = locationDetails[0];
        country = locationDetails[1];
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;
      });

      await getLocalities(city, country);

      if (localities.length == 0) {
        localities.add(city);

        await FirebaseFirestore.instance
            .collection("suggestions")
            .doc(postId)
            .set({
          "suggestion": "$city, $country",
          "username": GoTour.account.username,
          "timestamp": DateTime.now().millisecondsSinceEpoch
        });
      }
    }
  }

  controlUploadAndSave() async {
    if (nameTextEditingController.text.isNotEmpty &&
        typeTextEditingController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

      String downloadUrl = await FirebaseManager().uploadPhoto(
        mImageFile: imageList[0],
        postId: postId,
        fileName: "post_$postId.jpg",
        folderName: "Post Pictures",
        isMultiple: true,
      );

      await savePostInfoToFireStore(
        postId: postId,
        url: downloadUrl,
        name: nameTextEditingController.text,
        type: typeTextEditingController.text.trim(),
        locality: localityTextEditingController.text.isNotEmpty
            ? localityTextEditingController.text.trim()
            : "",
        currency: currencyTextEditingController.text.isNotEmpty
            ? currencyTextEditingController.text
            : "",
        payPeriod: payPeriodTextEditingController.text.isNotEmpty
            ? payPeriodTextEditingController.text
            : "",
        price: priceTextEditingController.text.isNotEmpty
            ? priceTextEditingController.text.replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')
            : "",
        city: city.isNotEmpty ? city : "",
        country: country,
        latitude: latitude,
        longitude: longitude,
        ownerUrl: GoTour.account.url,
        mobile: GoTour.account.phone,
        email: GoTour.account.email,
        address: addressTextEditingController.text.isNotEmpty
            ? addressTextEditingController.text
            : "",
        description: descriptionTextEditingController.text.isNotEmpty
            ? descriptionTextEditingController.text
            : "",
      );

      descriptionTextEditingController.clear();
      nameTextEditingController.clear();
      typeTextEditingController.clear();
      localityTextEditingController.clear();
      currencyTextEditingController.clear();
      payPeriodTextEditingController.clear();
      priceTextEditingController.clear();
    } else {
      Fluttertoast.showToast(
          msg: "Fill in the required fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.4));
    }
  }

  savePostInfoToFireStore(
      {String postId,
      String url,
      String name,
      String type,
      String locality,
      String description,
      String currency,
      String payPeriod,
      String price,
      String city,
      String country,
      double latitude,
      double longitude,
      String mobile,
      String email,
      String ownerUrl,
      String address}) async {
    bool isMe = (GoTour.account.id == brian.id);

    await postsReference.doc(postId).set({
      "postId": postId,
      "ownerId": isMe ? mickey.id : GoTour.account.id,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "username": isMe ? mickey.username : GoTour.account.username,
      "description": description,
      "url": url,
      "name": name,
      "type": type,
      "locality": locality,
      "currency": currency,
      "searchKey": name.toLowerCase(),
      "payPeriod": payPeriod,
      "price": price,
      "city": city,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "ownerUrl": isMe ? mickey.url : ownerUrl,
      "phone": isMe ? mickey.phone : mobile,
      "address": address,
      "email": isMe ? mickey.email : email
    }).then((value) async {
      if (imageList.length != 0) {
        await uploadImages(postId);
      }
      if (videoList.length != 0) {
        await uploadVideos(postId);
      }

      String userId = isMe ? mickey.id : GoTour.account.id;

      await usersReference.doc(userId).get().then((value) {
        if (!value.data().containsKey("posts")) {
          value.reference.set({
            "posts": 1,
          }, SetOptions(merge: true));
        } else {
          value.reference.update({
            "posts": value.get("posts") + 1,
          });
        }
      });
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Post Uploaded Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.4));

      Navigator.pop(context);
    });
  }

  uploadImages(String postId) async {
    for (var imageFile in imageList) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = imageFile.path.split(".").last;

      await FirebaseManager()
          .uploadPhoto(
        mImageFile: imageFile,
        postId: postId,
        fileName: "${fileName}_$postId.$extension",
        folderName: "Post Pictures",
        isMultiple: true,
      )
          .then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == imageList.length) {
          postsReference.doc(postId).collection("other images").add({
            'urls': imageUrls,
            //"names": imageFileNames,
          }).then((_) {
            setState(() {
              //imageList = [];
              imageUrls = [];
              imageFileNames = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  uploadVideos(String postId) async {
    for (var videoFile in videoList) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = videoFile.path.split(".").last;

      await FirebaseManager()
          .uploadPhoto(
        mImageFile: videoFile,
        postId: postId,
        fileName: "${fileName}_$postId.$extension",
        folderName: "Post Pictures",
        isMultiple: true,
      )
          .then((downloadUrl) {
        videoUrls.add(downloadUrl.toString());
        if (videoUrls.length == videoList.length) {
          postsReference.doc(postId).collection("videos").add({
            "urls": videoUrls,
            //"names": videoFileNames,
          }).then((_) {
            setState(() {
              videoList = [];
              videoUrls = [];
              videoFileNames = [];
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: loading
          ? circularProgress()
          : NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 3.0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    centerTitle: true,
                    title: Text(
                      "New Post",
                      style: TextStyle(
                          color: isShrink ? Colors.teal : Colors.white,
                          fontSize: width * 0.05, //24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: isShrink
                                ? Colors.grey
                                : Colors.white //Colors.white,
                            ),
                        onPressed: clearPostInfo),
                    expandedHeight: MediaQuery.of(context).size.height * 0.45,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                                image: DecorationImage(
                                  image: FileImage(imageList[0]),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          // Positioned(
                          //   bottom: 20.0,
                          //   right: 20.0,
                          //   child: button1(),
                          // ),
                          // Positioned(
                          //   bottom: 20.0,
                          //   left: 20.0,
                          //   child: button2(),
                          // )
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    displayImages(),
                    displayVideos(),
                    CustomField(
                        controller: nameTextEditingController,
                        hintText: "Name*",
                        width: width,
                        isDigits: false,
                        widget: null),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Location has been identified as:",
                          ),
                          Text(
                            city == null && country == null ||
                                    city == "" && country == ""
                                ? "Unknown"
                                : "$city, $country",
                            style: TextStyle(
                                //fontSize: MediaQuery.of(context).size.width * 0.040,
                                color: city == null && country == null ||
                                        city == "" && country == ""
                                    ? Colors.red
                                    : isBright
                                        ? Colors.black
                                        : Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          FlatButton.icon(
                            splashColor: Colors.teal.shade100,
                            icon: Icon(
                              Icons.edit_location_outlined,
                              color: Colors.teal,
                            ),
                            onPressed: editLocation,
                            label: Text(
                              "Edit Location",
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          city == null && country == null ||
                                  city == "" && country == ""
                              ? Text("")
                              : Text(
                                  "Any content you publish will be considered to be located in $city, $country.",
                                ),
                          SizedBox(
                            height: 12.0,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: PostType.types,
                          label: "Category",
                          hint: "Category",
                          //popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (v) {
                            setState(() {
                              typeTextEditingController.text = v;
                            });
                          },
                          //selectedItem: "Brazil"
                        ),
                      ),
                      title: Text(
                        "Choose your category*",
                        style: GoogleFonts.fredokaOne(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Where is it Located in $city",
                        style: GoogleFonts.fredokaOne(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownSearch<String>(
                        mode: Mode.DIALOG,
                        showSelectedItems: true,
                        items: localities,
                        label: "Locality(Optional)",
                        hint: "Locality(Optional)",
                        // validator: (String item) {
                        //   if (item == null)
                        //     return "Required";
                        //   else
                        //     return null;
                        // },
                        //popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (v) {
                          setState(() {
                            localityTextEditingController.text = v;
                          });
                          print(localityTextEditingController.text);
                        },
                        //selectedItem: "Brazil"
                      ),
                    ),
                    // CustomField(
                    //     controller: localityTextEditingController,
                    //     hintText: "Locality",
                    //     width: width,
                    //     isDigits: false,
                    //     widget: IconButton(
                    //       icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 20.0,),
                    //       onPressed: () {},
                    //     )
                    // ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Cost",
                        style: GoogleFonts.fredokaOne(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: ["Ksh", "Dollars", "Rands"],
                        label: "Currency(Optional)",
                        hint: "Currency(Optional)",
                        // validator: (String item) {
                        //   if (item == null)
                        //     return "Required field";
                        //   else
                        //     return null;
                        // },
                        //popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (v) {
                          if (v == "Dollars") {
                            setState(() {
                              currencyTextEditingController.text = r"$";
                            });
                          } else {
                            setState(() {
                              currencyTextEditingController.text = v;
                            });
                          }
                        },
                        //selectedItem: "Brazil"
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomField(
                        controller: priceTextEditingController,
                        hintText: "Price(Optional)",
                        width: width,
                        isDigits: true,
                        widget: null),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomField(
                            controller: payPeriodTextEditingController,
                            hintText: "Payment Period / Type(Optional)",
                            width: width,
                            isDigits: false,
                            widget: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30.0,
                            ),
                            offset: Offset(0.0, 50.0),
                            onSelected: periodAction,
                            itemBuilder: (BuildContext context) {
                              return Period.periods.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomField(
                        controller: addressTextEditingController,
                        hintText: "Address(Optional)",
                        width: width,
                        isDigits: false,
                        widget: null),
                    SizedBox(
                      height: 40.0,
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Other Details",
                        style: GoogleFonts.fredokaOne(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CustomField(
                        controller: descriptionTextEditingController,
                        hintText: "Description(Optional)",
                        width: width,
                        isDigits: false,
                        widget: null),
                    SizedBox(
                      height: 30.0,
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
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
