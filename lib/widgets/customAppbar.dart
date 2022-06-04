// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/Config/config.dart';
import 'package:gotour/pages/searchPage.dart';

class CustomAppBar extends StatelessWidget {
  final bool showArrow;
  const CustomAppBar({Key key, this.showArrow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: showArrow
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.grey,
              ),
            )
          : Container(),
      actions: [
        CircleAvatar(
          radius: 15.0,
          backgroundImage: NetworkImage(GoTour.account.url),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.grey,
          ),
        )
      ],
      title: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(builder: (context) => SearchPage());
            Navigator.push(context, route);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: size.height * 0.05,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Search here...",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .apply(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
