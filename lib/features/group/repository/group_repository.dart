import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/features/group/model/groupModel.dart';
import 'package:whatsapp_app/utils/utils.dart';

class GroupRepository {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  GroupRepository(
      {required this.firebaseFirestore, required this.firebaseAuth});

  Future<void> createGroup(BuildContext context, String name, File profile,
      List<Contact> contacts) async {
    try {
      List<String> uids = [];

      for (int i = 0; i < contacts.length; i++) {
        var collection = await firebaseFirestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    " ",
                    "",
                  ),
            )
            .get();

        if (collection.docs.isNotEmpty && collection.docs[0].exists) {
          uids.add(collection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String imageUrl =
          await FirebaseStorages(firebaseStorage: FirebaseStorage.instance)
              .uploadFile(profile, '/group/$groupId');
      GroupModel groupModel = GroupModel(
        senderId: firebaseAuth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        // profilePicture: firebaseAuth.currentUser!.photoURL!,
        groupPicture: imageUrl,
        memberId: [firebaseAuth.currentUser!.uid, ...uids],
        timestamp: DateTime.now(),
      );

      await firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set(groupModel.toJson());
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Stream<List<GroupModel>> getGroups() {
    return firebaseFirestore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];

      for (var element in event.docs) {
        var group = GroupModel.fromJson(element.data());
        if (group.memberId.contains(firebaseAuth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }
}
