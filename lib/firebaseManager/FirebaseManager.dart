// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseManager {
  Future<String> uploadPhoto(
      {File mImageFile,
      String postId,
      String fileName,
      String folderName,
      bool isMultiple}) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    var storageReference = storage.ref().child(folderName);

    firebase_storage.UploadTask task = isMultiple
        ? storageReference.child(postId).child(fileName).putFile(mImageFile)
        : storageReference.child(fileName).putFile(mImageFile);

    firebase_storage.TaskSnapshot snapshot = await task;
    Future<String> downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
