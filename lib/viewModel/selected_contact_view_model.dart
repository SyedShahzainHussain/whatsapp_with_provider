import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_app/repository/selected_contact.dart';

class SelectedContactViewModel with ChangeNotifier {
  final SelectedContactRepository selectedContactRepository =
      SelectedContactRepository(firestore: FirebaseFirestore.instance);

  Future<List<Contact>> getContact() async {
    final List<Contact> contact = await selectedContactRepository.getContact();
    return contact;
  }

  void selectedContact(BuildContext context, Contact selectedContact) async {
    await selectedContactRepository.selectedContact(context, selectedContact);
  }
}
