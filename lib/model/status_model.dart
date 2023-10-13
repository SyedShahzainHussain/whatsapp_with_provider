import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final String profilePic;
  final String statusId;
  final List<String> photosurl;
  final List<String> whocansee;
  final DateTime dateTime;

  StatusModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.profilePic,
    required this.statusId,
    required this.photosurl,
    required this.whocansee,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'photosurl': photosurl,
      'whocansee': whocansee,
      'username': username,
      'phoneNumber': phoneNumber,
      'profile': profilePic,
      'statusId': statusId,
      'dateTime': dateTime
    };
  }

  factory StatusModel.fromJSon(Map<String, dynamic> json) {
    return StatusModel(
        uid: json['uid'] ?? '',
        username: json['username'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        profilePic: json['profile'] ?? '',
        statusId: json['statusId'] ?? '',
        photosurl: List<String>.from(json['photosurl']),
        whocansee: List<String>.from(json['whocansee']),
        dateTime: (json['dateTime'] as Timestamp).toDate() );
  }
}
