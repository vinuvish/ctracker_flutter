import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class ZFirebaseStorage {
  static Future<String> uploadImageFile({File imageFile}) async {
    print('imageFile $imageFile');
    var uuid = new Uuid();

    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images').child("${uuid.v1()}.jpg");

    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(imageFile);

    return await taskSnapshot.ref.getDownloadURL();
  }
}
