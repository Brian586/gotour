// ignore_for_file: file_names

import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image/image.dart' as ui;

class MyDownloader {
  Future<void> downloadImage({String url, String subDir, String postId}) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    var imageId = await ImageDownloader.downloadImage(
      url,
      // destination: AndroidDestinationType.custom(
      //   inPublicDir: true,
      //   directory: "Gotour",
      // )..subDirectory("${subDir}/${timestamp}_${postId}.png"),
    );

    if (imageId == null) {
      return;
    }

    try {
      // Below is a method of obtaining saved image information.
      var path = await ImageDownloader.findPath(imageId);

      print("============$path=============");

      ui.Image originalImage = ui.decodeImage(File(path).readAsBytesSync());

      ui.Image image = ui.Image(originalImage.width, originalImage.height);

      ui.drawString(image, ui.arial_24, 100, 120, "Gotour App");
    } catch (e) {
      print("============${e.toString()}==============");
    }

    Fluttertoast.showToast(msg: "Image Downloaded Successfully");
  }
}
