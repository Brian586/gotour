import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkwell/linkwell.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("About", style: GoogleFonts.fredokaOne(color: Colors.teal),),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.help_outline_rounded, color: Colors.grey,),
              title: Text("About This App", style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text(
                "General Information About Gotour Kenya",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Route route = MaterialPageRoute(builder: (context)=> AboutApp());
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt_long_rounded, color: Colors.grey,),
              title: Text("Terms and Conditions", style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text(
                "Our terms of use",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Route route = MaterialPageRoute(builder: (context)=> TermsAndConditions(
                  isVisible: true,
                ));
                Navigator.push(context, route);
              },
            ),
            ListTile(
              leading: Icon(Icons.email_outlined, color: Colors.grey,),
              title: Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold,),),
              subtitle: Text(
                "Get to know more",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () => launch("mailto:gotourkenya@gmail.com"),
            ),
          ],
        ),
      ),
    );
  }
}


class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("About App", style: GoogleFonts.fredokaOne(color: Colors.teal),),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gotour Kenya is the best app to publish cool places and get clients for free! "
                    "\n\nThe app was created to improve on marketing experience. Users can locate "
                    "content they need with much ease. Publish anything from Adventures, Apartments, "
                    "Hostels, Hotels, Lodges/Guest Houses, Resorts, rental houses or land.",
              ),
              SizedBox(height: 20,),
              Text("A CUSTOMIZED EXPERIENCE", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              Text(
                "The app allows different users to enjoy a customized experience, tailored to their needs. ",
              ),
              SizedBox(height: 20,),
              Text("HOW THE APP WORKS", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              Text(
                "The app lets users to publish and view content from different places in Kenya. You can publish anything and anyone using the app gets to view and contact you through a phone call, text message or email. All published content is categorised according to its location. Users can locate this content simply by selecting their desired location. Anyone can save places by adding them to favourites.",
              ),
              SizedBox(height: 20,),
              Text("HOW TO PUBLISH CONTENT", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              Text(
                "If you are looking to publish content related to the categories above, then this is the best platform to do so. ",
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Click on the Drawer icon.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Click on Upload.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Let the app determine your current Location.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Choose your category",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Click Proceed",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Capture image.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Fill in the required details.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Any other information should be included in the Description.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Click Share.",
                ),
              ),
              Text(
                "All you need to do is be there in that exact location while publishing content to help other users know where the place is located on Google Maps.",
              ),
              SizedBox(height: 20,),
              Text("KEY FEATURES", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              Text(
                "Location services – You can easily locate places with the newly integrated Google Maps. ",
              ),
              Text(
                "Contact Information – Users can communicate through email, call or text messages. ",
              ),
              Text(
                "Efficient searches for desired destinations.",
              ),
              Text(
                "Free publishing ",
              ),
              SizedBox(height: 20,),
              Text("SECURITY", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              Text(
                "User data is safe with the system’s advanced security rules. If any user encounters stolen content or other challenges, feel free to contact Gotour Kenya through email: gotourkenya@gmail.com",
              ),
              SizedBox(height: 20,),
              Text("FOLLOW US", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              LinkWell(
                "Instagram: https://www.instagram.com/gotour_kenya/",
                style: TextStyle(color: isBright ? Colors.black: Colors.white),
                linkStyle: TextStyle(color: Colors.teal,),
              ),
              SizedBox(height: 10,),
              LinkWell(
                "Twitter: https://twitter.com/GotourK",
                style: TextStyle(color: isBright ? Colors.black: Colors.white),
                linkStyle: TextStyle(color: Colors.teal, ),
              ),
              SizedBox(height: 50.0,),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndConditions extends StatelessWidget {

  final bool isVisible;

  TermsAndConditions({this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Terms and Conditions", style: GoogleFonts.fredokaOne(color: Colors.teal),),
        centerTitle: true,
        leading: isVisible ? IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey,),
            onPressed: () {
              Navigator.pop(context);
            }
        ) : Text(""),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Data we process", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("We store information you give us "
                    "i.e your name,phone number, device location and email address.",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("This information helps our services deliver more useful, "
                    "customized content such as more relevant search results;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Improve the quality of our services and develop new ones;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Improve security by protecting against fraud and abuse;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("Conduct analytics and measure to understand how our services are used.",
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Tracking Services", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("This App tracks location data. Uploading content "
                    "requires that your device location be turned on;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("The algorithm works in the sense that you have to "
                    "be there in that exact location as you upload your content;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("This data is used to identify the exact location "
                    "of the place you're advertising and help clients interested"
                    " in your content to know the exact location.",
                ),
              ),
              SizedBox(height: 20.0,),
              Text("Payment and mobile transactions", style: GoogleFonts.fredokaOne(),),
              SizedBox(height: 10,),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("This app is free to use;",
                ),
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 15.0,),
                title: Text("We DO NOT allow users to handle payments through the app.",
                ),
              ),
              SizedBox(height: 30.0,),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("I agree", style: GoogleFonts.fredokaOne(color: Colors.white,),),
                  elevation: 6.0,
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




