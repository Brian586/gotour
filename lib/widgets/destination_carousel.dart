import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/pages/destinationPage.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DestinationCarousel extends StatelessWidget {
  final Destination destination;

  const DestinationCarousel({
    Key key,
    @required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DestinationPage(
            destination: destination,
          ),
        ),
      ),
      child: ResponsiveBuilder(
        builder: (context, sizeInfo) {
          bool isDesktop = sizeInfo.isDesktop;

          return Container(
            margin: const EdgeInsets.all(10.0),
            width: isDesktop ? size.width * 0.17 : size.width * 0.5, //210.0,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  bottom: size.height * 0.01, //15.0,
                  child: Container(
                    height: size.height * 0.15, //120.0,
                    width: isDesktop ? size.width * 0.16 : size.width * 0.48, //200.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: isBright ? Colors.black26 : Colors.black87,
                          offset: const Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      color: isBright
                          ? Colors.white
                          : const Color.fromRGBO(48, 48, 48, 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /*Text(
                        //'${destination.activities.length} activities',
                        "0 activities",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),*/
                          Text(
                            destination.description.trimRight(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isBright
                        ? Colors.white
                        : const Color.fromRGBO(48, 48, 48, 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: isBright ? Colors.black26 : Colors.black87,
                        offset: const Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: destination.imageUrl,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          // child: CachedNetworkImage(
                          //   imageUrl: destination.imageUrl,
                          //   height: size.height * 0.21,
                          //   width: size.width * 0.44,
                          //   fit: BoxFit.cover,
                          //   progressIndicatorBuilder:
                          //       (context, url, downloadProgress) => Center(
                          //     child: Container(
                          //       height: 50.0,
                          //       width: 50.0,
                          //       child: CircularProgressIndicator(
                          //           strokeWidth: 1.0,
                          //           value: downloadProgress.progress,
                          //           valueColor:
                          //               AlwaysStoppedAnimation(Colors.grey)),
                          //     ),
                          //   ),
                          //   errorWidget: (context, url, error) => Icon(
                          //     Icons.error_outline_rounded,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/loader.gif",
                            placeholderScale: 0.2,
                            height: size.height * 0.21, //180.0,
                            width: isDesktop ? size.width * 0.15 : size.width * 0.44, //180.0,
                            image: destination.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          height: 80.0,
                          width: size.height * 0.21,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              gradient: LinearGradient(
                                  colors: [Colors.black54, Colors.transparent],
                                  begin: FractionalOffset.bottomCenter,
                                  end: FractionalOffset.topCenter)),
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        bottom: 10.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              destination.city,
                              style: const TextStyle(
                                color: Colors.white,
                                //fontSize: size.width * 0.05,//24.0,
                                fontWeight: FontWeight.bold,
                                //letterSpacing: 1.2,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: isDesktop ? 12.0 : size.width * 0.038, //10.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  destination.country,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } ,
      ),
    );
  }
}
