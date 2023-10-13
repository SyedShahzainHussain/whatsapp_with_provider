import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/status_model.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/utils/utils.dart';

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorages firebaseStorage;
  StatusRepository(
      {required this.auth,
      required this.firestore,
      required this.firebaseStorage});

  void uploadStatus({
    required String username,
    required String phoneNumber,
    required String profilePic,
    required File statusIamge,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      final imageUrl = await firebaseStorage.uploadFile(
        statusIamge,
        '/status/$statusId/$uid',
      );

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);

        List<String> uidWhoCanSee = [];
        for (int i = 0; i < contacts.length; i++) {
          var userDataCollection = await firestore
              .collection('users')
              .where('phoneNumber',
                  isEqualTo: contacts[i].phones[0].number.replaceAll(" ", ""))
              .get();

          if (userDataCollection.docs.isNotEmpty) {
            var userData =
                UserModel.fromJson(userDataCollection.docs[0].data());
            uidWhoCanSee.add(userData.uid);
          }
        }
        List<String> statusIamgeUrls = [];
        var statusesSnapShot = await firestore
            .collection('status')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            .get();

        if (statusesSnapShot.docs.isNotEmpty) {
          StatusModel statusModel =
              StatusModel.fromJSon(statusesSnapShot.docs[0].data());
          statusIamgeUrls = statusModel.photosurl;
          statusIamgeUrls.add(imageUrl);
          await firestore
              .collection('status')
              .doc(statusesSnapShot.docs[0].id)
              .update({'photosurl': statusIamgeUrls});
          return;
        } else {
          statusIamgeUrls = [imageUrl];
        }

        StatusModel statusModel = StatusModel(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          profilePic: profilePic,
          statusId: statusId,
          photosurl: statusIamgeUrls,
          whocansee: uidWhoCanSee,
          dateTime: DateTime.now(),
        );

        await firestore
            .collection('status')
            .doc(statusId)
            .set(statusModel.toJson())
            .then((val) {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> status = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusData = await firestore
            .collection('status')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(" ", ""))
            .where("dateTime",
                isGreaterThan:
                    DateTime.now().subtract(const Duration(hours: 24)))
            .get();
        for (var tempdata in statusData.docs) {
          StatusModel model = StatusModel.fromJSon(tempdata.data());
          if (model.whocansee.contains(auth.currentUser!.uid)) {
            status.add(model);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);

      // ignore: use_build_context_synchronously
      Utils.showSnackBar(context, e.toString());
    }
    return status;
  }
}
