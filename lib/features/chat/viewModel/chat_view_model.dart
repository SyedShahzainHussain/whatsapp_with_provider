import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/chat/model/chat_contact_model.dart';
import 'package:whatsapp_app/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/message.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/provider/message_reply.dart';

class ChatViewModel with ChangeNotifier {
  ChatRepository chatRepository =
      ChatRepository(FirebaseFirestore.instance, FirebaseAuth.instance);

  sendTextMessage(
    BuildContext context,
    String text,
    String receiverId,
    UserModel senderUser,
    bool isGroup,
  ) async {
    await chatRepository.sendTextMessage(
      context: context,
      text: text,
      receiverId: receiverId,
      senderUser: senderUser,
      messageReply: context.read<MessageReplyProvider>().messageReply,
      isGroup: isGroup,
    );
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContact();
  }

  Stream<List<MessageModel>> getMessageContacts(String receiverId) {
    return chatRepository.getMessages(receiverId);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    FirebaseStorages firebaseStorages,
    MessageEnum messageEnum,
    String receiverId,
    UserModel senderModel,
    bool isGroup,
  ) {
    chatRepository.sendFileMessage(
      context: context,
      file: file,
      firebaseStorages: firebaseStorages,
      messageEnum: messageEnum,
      receiverId: receiverId,
      senderUserData: senderModel,
      messageReply: context.read<MessageReplyProvider>().messageReply,
      isGroup: isGroup,
    );
  }

  void sendGifMessage(
    BuildContext context,
    String url,
    String receiverId,
    UserModel senderModel,
    bool isGroup,
  ) {
    int gifUrlPartIndex = url.lastIndexOf('-') + 1;
    String gifUrlPart = url.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    chatRepository.sendGif(
      context: context,
      url: newGifUrl,
      receiverId: receiverId,
      senderData: senderModel,
      messageReply: context.read<MessageReplyProvider>().messageReply,
      isGroup: isGroup,
    );
  }

  void setChatMessageSeen(
      BuildContext context, String receiverId, String messageId) {
    chatRepository.setChatMessageSeen(context, receiverId, messageId);
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return chatRepository.getMessage(groupId);
  }
}
