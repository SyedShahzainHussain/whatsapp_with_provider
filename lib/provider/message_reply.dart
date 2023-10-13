import 'package:flutter/material.dart';
import 'package:whatsapp_app/enum/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;
  MessageReply(
    this.message,
    this.isMe,
    this.messageEnum,
  );
}

class MessageReplyProvider extends ChangeNotifier {
  MessageReply? _messageReply;
  MessageReply? get messageReply => _messageReply;

  void setMessageReply(MessageReply? messageReply) {
    _messageReply = messageReply;
    notifyListeners();
  }
}
