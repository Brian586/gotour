import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/models/PostModel.dart';

import '../main.dart';
import 'editProfilePage.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //final PostDataBaseManager postDataBaseManager = PostDataBaseManager();

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void changeColor() {
    DynamicTheme.of(context).setThemeData(ThemeData(
        primaryColor: Theme.of(context).primaryColor == Colors.indigo
            ? Colors.red
            : Colors.indigo));
  }

  clearData() async {
    //await postDataBaseManager.clearTable();

    Route route = MaterialPageRoute(builder: (context) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }

  showOptions(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Clear Cache",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text("Proceed to clear App data"), onPressed: clearData),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = DynamicTheme.of(context).brightness == Brightness.dark;
    double width = MediaQuery.of(context).size.width;
    bool isAdmin = GoTour.account.role == "Seller";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Settings",
          style: GoogleFonts.fredokaOne(color: Colors.teal),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.color_lens_outlined,
                color: Colors.grey,
              ),
              title: const Text(
                "Change Theme",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Switch(
                activeColor: Colors.teal,
                inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveTrackColor: Colors.grey,
                value: isDark,
                onChanged: (value) {
                  changeBrightness();
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.cleaning_services_outlined,
                color: Colors.grey,
              ),
              title: const Text(
                "Clear Cache",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Clear App data",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () => showOptions(context),
            ),
            isAdmin
                ? const Text("")
                : ListTile(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => EditProfilePage());
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(GoTour.account.url),
                    ),
                    title: const Text(
                      "Edit Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      "Change your Account Information",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
