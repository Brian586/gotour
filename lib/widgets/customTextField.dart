import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';


class CustomField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final double width;
  final Widget widget;
  bool isDigits = false;

  CustomField({
    @required this.controller,
    @required this.hintText,
    @required this.width,
    @required this.isDigits,
    @required this.widget,
});

  @override
  Widget build(BuildContext context) {

    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            //color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: TextFormField(
            maxLines: null,
            cursorColor: Colors.teal,
            style: TextStyle(color: isBright ? Colors.black : Colors.white),
            controller: controller,
            keyboardType: isDigits ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              filled: true,
              suffix: widget,
            ),
            validator: (value) {
              if(value.isEmpty)
              {
                return "Required";
              }
              else
              {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
