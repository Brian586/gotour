import 'package:flutter/material.dart';


class AddImage extends StatelessWidget {

  final Function onPressed;
  final IconData iconData;

  AddImage({@required this.onPressed, this.iconData});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
            height: 90.0,
            width: 110.0,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Center(
              child: Icon(iconData, color: Colors.grey, size: 30.0,),
            )
        ),
      ),
    );
  }
}
