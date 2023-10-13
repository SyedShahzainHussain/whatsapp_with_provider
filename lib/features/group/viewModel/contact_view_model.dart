import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:whatsapp_app/features/group/model/groupModel.dart';
import 'package:whatsapp_app/features/group/repository/group_repository.dart';

class ContactViewModel with ChangeNotifier {
  GroupRepository groupRepository = GroupRepository(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance);
  final List<int> _selectedContact = [];
  final List<Contact> _selectedContacts = [];

  List<int> get selectedContact => _selectedContact;
  List<Contact> get selectedContacts => _selectedContacts;
  void selectedContacted(int index, Contact contact) {
    if (_selectedContact.contains(index)) {
      _selectedContact.remove(index);
      _selectedContacts.remove(contact);
    } else {
      _selectedContact.add(index);
      _selectedContacts.add(contact);
    }
    notifyListeners();
  }

  void clearSelectedContact() {
    _selectedContact.clear();
    notifyListeners();
  }

  void clearSelectedContacts() {
    _selectedContacts.clear();
    notifyListeners();
  }

  Future createGroup(BuildContext context, String name, File profile,
      List<Contact> contacts) async {
    await groupRepository.createGroup(context, name, profile, contacts);
  }

  Stream<List<GroupModel>> getGroups() {
    return groupRepository.getGroups();
  }
}
