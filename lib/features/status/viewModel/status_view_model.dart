import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/status_model.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/features/status/repository/status_repository.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';

class StatusViewModel with ChangeNotifier {
  StatusRepository statusRepository = StatusRepository(
      auth: FirebaseAuth.instance,
      firebaseStorage:
          FirebaseStorages(firebaseStorage: FirebaseStorage.instance),
      firestore: FirebaseFirestore.instance);

  void uploadStatus(BuildContext context, File statusImage) async {
    UserModel? user = await context.read<PhoneAuthViewModel>().getUserData();
    if (user != null) {
      // Now you can safely use the user object here
      statusRepository.uploadStatus(
        username: user.name,
        phoneNumber: user.phoneNumber,
        profilePic: user.photosUrl,
        statusIamge: statusImage,
        context: context,
      );
    } else {
      // Handle the case where user is null (if necessary)
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> status = await statusRepository.getStatus(context);
    return status;
  }
}
