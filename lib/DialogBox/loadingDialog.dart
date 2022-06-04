// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotour/widgets/ProgressWidget.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String message;
  const LoadingAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message),
        ],
      ),
    );
  }
}
