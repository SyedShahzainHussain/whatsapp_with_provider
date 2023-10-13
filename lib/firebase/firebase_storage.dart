import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorages {
  final FirebaseStorage firebaseStorage;
  FirebaseStorages({required this.firebaseStorage});

  Future<String> uploadFile(File file, String ref) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    final String dounloadUrl = await taskSnapshot.ref.getDownloadURL();
    return dounloadUrl;
  }
}
