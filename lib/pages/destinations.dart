import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/providers/destinationProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/customAppbar.dart';
import 'package:gotour/widgets/destinationItem.dart';
import 'package:gotour/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Destinations extends StatefulWidget {
  const Destinations({Key key}) : super(key: key);

  @override
  _DestinationsState createState() => _DestinationsState();
}

class _DestinationsState extends State<Destinations> {
  // bool loading = false;
  // bool loadingOld = false;
  // DestinationDatabaseManager destinationDatabaseManager =
  //     DestinationDatabaseManager();
  //Future<List<Destination>> futureDestinationResults;
  // BannerAd banner;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final adState = Provider.of<AdState>(context);
  //   adState.initialization.then((status) {
  //     setState(() {
  //       banner = BannerAd(
  //           size: adState.adSize,
  //           adUnitId: adState.bannerAdUnitId,
  //           listener: adState.adListener,
  //           request: adState.request
  //       )..load();
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   getDestinations();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   banner?.dispose();
  // }

  // Future<void> getDestinations() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   await DestinationProvider().updateDestinationDB();

  //   //Future<List<Destination>> destinations = ;

  //   // var timestamp = await destinationDatabaseManager.getTimestamp('DESC');
  //   //
  //   // await destinationsReference
  //   //     .where("timestamp", isGreaterThan: timestamp)
  //   //     .orderBy("timestamp", descending: false)
  //   //     .limit(5)
  //   //     .get()
  //   //     .then((querySnapshot) {
  //   //   querySnapshot.docs.forEach((document) async {
  //   //     Destination destination = Destination.fromDocument(document);
  //   //     await destinationDatabaseManager
  //   //         .insertDestination(destination)
  //   //         .then((value) => {print("data inserted successfully")});
  //   //   });
  //   // });

  //   setState(() {
  //     loading = false;
  //     //futureDestinationResults = destinations;
  //   });
  // }

  displayDestinations() {
    return FutureBuilder(
      future: context.watch<DestinationProvider>().getDestinations(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        } else {
          List<Destination> destinationList = dataSnapshot.data;

          if (destinationList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/nodata.png"),
                  height: 100.0,
                  width: 100.0,
                ),
                const Text(
                  "No Data",
                  style: TextStyle(color: Colors.grey, fontSize: 17.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  //width: 250.0,
                  height: 60.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    elevation: 5.0,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.teal,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: destinationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Destination destination = destinationList[index];

                      return DestinationItem(
                        destination: destination,
                      );
                    },
                  ),
                  //AdLayout(banner: banner),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 60.0,
                      alignment: Alignment.center,
                      child: RaisedButton.icon(
                        elevation: 5.0,
                        onPressed: () {
                          context
                              .read<DestinationProvider>()
                              .loadOldDestinations();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.teal,
                        ),
                        label: Text(
                          "Load More",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<DestinationProvider>().updateDestinationDB();

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        if (sizeInfo.isDesktop) {
          return DesktopViewDestinations(
            displayDestinations: displayDestinations(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "Destinations",
              style: GoogleFonts.fredokaOne(color: Colors.teal),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: RefreshIndicator(
            child: displayDestinations(),
            onRefresh: () =>
                context.read<DestinationProvider>().updateDestinationDB(),
          ),
        );
      },
    );
  }
}

class DesktopViewDestinations extends StatelessWidget {
  final Widget displayDestinations;

  const DesktopViewDestinations({Key key, this.displayDestinations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 2,
            child: CustomDrawer(),
          ),
          Expanded(
            flex: 8,
            child: Scaffold(
              appBar: PreferredSize(
                child: const CustomAppBar(
                  showArrow: true,
                ),
                preferredSize: Size(size.width, size.height * 0.07),
              ),
              body: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: displayDestinations,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
