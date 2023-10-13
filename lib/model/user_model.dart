class UserModel {
  final String name;
  final String photosUrl;
  final String phoneNumber;
  final bool isOnline;
  final List<String> groupId;
  final String uid;

  UserModel(
      {required this.name,
      required this.photosUrl,
      required this.phoneNumber,
      required this.isOnline,
      required this.groupId,
      required this.uid});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photosUrl': photosUrl,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'groupId': groupId,
      'uid': uid
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      photosUrl: map['photosUrl'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isOnline: map['isOnline'] ?? '',
      groupId: List<String>.from(map['groupId']),
      uid: map['uid'] ?? '',
    );
  }
}
