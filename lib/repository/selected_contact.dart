import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/utils/utils.dart';

class SelectedContactRepository {
  final FirebaseFirestore firestore;
  SelectedContactRepository({required this.firestore});

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> selectedContact(context, Contact selectedContact) async {
    try {
      var userData = await firestore.collection("users").get();
      bool isFound = false;
      for (var documents in userData.docs) {
        var users = UserModel.fromJson(documents.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        debugPrint(selectedPhoneNumber);
        if (selectedPhoneNumber == users.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, RouteName.chatScreen, arguments: {
            'name': users.name,
            'uid': users.uid,
            'image': users.photosUrl,
            'isGroup':false,
            
          });
        }
      }
        if (!isFound) {
          Utils.showSnackBar(
              context, 'This number does not exist on this app.');
        }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }
}
