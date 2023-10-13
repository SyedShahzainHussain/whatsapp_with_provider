class GroupModel {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  // final String profilePicture;
  final String groupPicture;
  final List<String> memberId;
  final DateTime timestamp;

  GroupModel({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    // required this.profilePicture,
    required this.groupPicture,
    required this.memberId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      // 'profilePicture': profilePicture,
      'groupPicture': groupPicture,
      'memberId': memberId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  GroupModel.fromJson(Map<String, dynamic> map)
      : senderId = map['senderId'],
        name = map['name'],
        groupId = map['groupId'],
        lastMessage = map['lastMessage'],
        // profilePicture = map['profilePicture'],
        memberId = List<String>.from(map['memberId']),
        groupPicture = map['groupPicture'],
        timestamp = DateTime.parse(map['timestamp']);
}
