// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/LocalityModel.dart';
import 'package:gotour/pages/localityPage.dart';

class LocalityWidget extends StatelessWidget {
  final Locality locality;

  const LocalityWidget({
    Key key,
    this.locality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocalityPage(
                        locality: locality,
                      )));
        },
        child: Stack(
          children: [
            Hero(
              tag: locality.imageUrl,
              child: Container(
                height: 180.0,
                width: 220.0,
                decoration: BoxDecoration(
                  color:
                      isBright ? Colors.white : Color.fromRGBO(48, 48, 48, 1.0),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: isBright ? Colors.black26 : Colors.black87,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  // child: CachedNetworkImage(
                  //   imageUrl: locality.imageUrl,
                  //   height: 180.0,
                  //   width: 220.0,
                  //   fit: BoxFit.cover,
                  //   progressIndicatorBuilder:
                  //       (context, url, downloadProgress) => Center(
                  //     child: Container(
                  //       height: 50.0,
                  //       width: 50.0,
                  //       child: CircularProgressIndicator(
                  //           strokeWidth: 1.0,
                  //           value: downloadProgress.progress,
                  //           valueColor: AlwaysStoppedAnimation(Colors.grey)),
                  //     ),
                  //   ),
                  //   errorWidget: (context, url, error) => Icon(
                  //     Icons.error_outline_rounded,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/loader.gif",
                    placeholderScale: 0.5,
                    image: locality.imageUrl,
                    fit: BoxFit.cover,
                    height: 180.0,
                    width: 220.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 100.0,
                width: 220.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter)),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 15.0,
              child: Text(
                locality.locality.trimRight(),
                style: const TextStyle(
                  color: Colors.white,
                  //fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
