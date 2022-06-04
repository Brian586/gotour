import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gotour/pages/home.dart';

class FileManager {
  // Pick single image

  pickSingleImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    return result.files.first.bytes;
  }

  // Pick Multiple images

  // Upload Images to firestore

  Future<String> uploadPhoto(mImageFile, String fileName) async {
    // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    // var storageReference = storage.ref().child("Products");

    firebase_storage.UploadTask task = profilePhotoReference
        //.child(postId)
        .child(fileName)
        .putData(mImageFile);

    firebase_storage.TaskSnapshot snapshot = await task;
    Future<String> downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
