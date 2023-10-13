import 'package:whatsapp_app/enum/message_enum.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum messageType;
  final DateTime timesSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.messageType,
    required this.timesSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "messageType": messageType.type,
      "timesSent": timesSent.toIso8601String(),
      "messageId": messageId,
      "isSeen": isSeen,
      "repliedMessage": repliedMessage,
      "repliedTo": repliedTo,
      "repliedMessageType": repliedMessageType.type,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      messageType: (map['messageType'] as String).toEnum(),
      timesSent: DateTime.parse(map['timesSent']),
      messageId: map['messageId'],
      isSeen: map['isSeen'],
      repliedMessage: map['repliedMessage'],
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
      repliedTo: map['repliedTo'],
    );
  }
}
