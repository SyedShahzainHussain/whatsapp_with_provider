import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContactModel {
  final String name;
  final String lastMessage;
  final DateTime? dateTime;
  final String profilePic;
  final String contactId;

  ChatContactModel({
    required this.name,
    required this.lastMessage,
    required this.dateTime,
    required this.profilePic,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'dateTime': dateTime,
      'profilePic': profilePic,
      'contactId': contactId,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      dateTime: map['dateTime'] is Timestamp
          ? (map['dateTime'] as Timestamp).toDate()
          : null,
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
    );
  }
}
