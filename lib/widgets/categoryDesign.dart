// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotour/models/Category.dart';
import 'package:gotour/models/user.dart';
import 'package:gotour/pages/categoryPage.dart';

class CategoryDesign extends StatelessWidget {
  final Category category;

  const CategoryDesign({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => CategoryPage(
                  category: category,
                ));
        Navigator.push(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 300.0,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: isBright ? Colors.white : const Color.fromRGBO(48, 48, 48, 1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: isBright ? Colors.black26 : Colors.black87,
                offset: const Offset(0.0, 2.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: category.imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  // child: CachedNetworkImage(
                  //   imageUrl: category.imageUrl,
                  //   height: 300.0,
                  //   width: width * 0.8,
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
                    image: category.imageUrl,
                    fit: BoxFit.cover,
                    height: 300.0,
                    width: width * 0.8,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.1, //100.0,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                ),
              ),
              Positioned(
                bottom: 7.0,
                left: 7.0,
                child: Container(
                  width: width * 0.8,
                  child: ListTile(
                    title: Text(
                      "${category.name}",
                      style: GoogleFonts.fredokaOne(
                        color: Colors.white,
                        //fontSize: width * 0.05,
                      ),
                    ),
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

class DiscoverLayout extends StatelessWidget {
  final Category category;

  const DiscoverLayout({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (context) => CategoryPage(category: category));
          Navigator.push(context, route);
        },
        child: Stack(
          children: [
            Container(
              height: size.width / 3,
              width: size.width / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                      image: NetworkImage(category.imageUrl),
                      fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                //width: size.width/3,
                height: size.width * 0.2,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5.0)),
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 5.0,
              child: Text(
                category.name.trimRight(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
