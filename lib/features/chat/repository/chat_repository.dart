import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_app/features/chat/model/chat_contact_model.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/message.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/provider/message_reply.dart';
import 'package:whatsapp_app/utils/utils.dart';

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository(
    this.firebaseFirestore,
    this.firebaseAuth,
  );

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel? receiverUserData,
    String text,
    DateTime timestamp,
    String receiverId,
    bool isGroup,
  ) async {
    if (isGroup) {
      await firebaseFirestore.collection('groups').doc(receiverId).update({
        "lastMessage": text,
        "timestamp": DateTime.now().toIso8601String(),
      });
    } else {
      var receiverChatContacts = ChatContactModel(
        name: senderUserData.name,
        lastMessage: text,
        dateTime: timestamp,
        profilePic: senderUserData.photosUrl,
        contactId: senderUserData.uid,
      );
      await firebaseFirestore
          .collection("users")
          .doc(receiverId)
          .collection("chats")
          .doc(firebaseAuth.currentUser!.uid)
          .set(
            receiverChatContacts.toMap(),
          );

      var senderChatContacts = ChatContactModel(
        name: receiverUserData!.name,
        lastMessage: text,
        dateTime: timestamp,
        profilePic: receiverUserData.photosUrl,
        contactId: receiverUserData.uid,
      );

      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("chats")
          .doc(receiverId)
          .set(
            senderChatContacts.toMap(),
          );
    }
  }

  void _saveMessageToSubMessageCollection({
    required String receiverId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? receiverUserName,
    required MessageEnum repliedMessageType,
    required bool isGroup,
  }) async {
    final message = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverId,
      text: text,
      messageType: messageType,
      timesSent: timesent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUserName ?? '',
      repliedMessageType: repliedMessageType,
    );
    if (isGroup) {
      await firebaseFirestore
          .collection('groups')
          .doc(receiverId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());

      await firebaseFirestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());
    }
  }

  Future<void> sendTextMessage({
    required context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroup,
  }) async {
    try {
      var time = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroup) {
        var userDataMap =
            await firebaseFirestore.collection("users").doc(receiverId).get();

        receiverUserData = UserModel.fromJson(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        text,
        time,
        receiverId,
        isGroup,
      );

      _saveMessageToSubMessageCollection(
          receiverId: receiverId,
          text: text,
          timesent: time,
          messageId: messageId,
          username: senderUser.name,
          messageType: MessageEnum.text,
          messageReply: messageReply,
          senderUsername: senderUser.name,
          receiverUserName: receiverUserData?.name,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum,
          isGroup: isGroup);
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Stream<List<ChatContactModel>> getChatContact() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var element in event.docs) {
        var chatContact = ChatContactModel.fromMap(element.data());
        var userData = await firebaseFirestore
            .collection("users")
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromJson(userData.data()!);
        contacts.add(
          ChatContactModel(
            name: user.name,
            lastMessage: chatContact.lastMessage,
            dateTime: chatContact.dateTime,
            profilePic: user.photosUrl,
            contactId: chatContact.contactId,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getMessages(String receiverId) {
    return firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("timesSent")
        .snapshots()
        .asyncMap((event) {
      List<MessageModel> messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      return messages;
    });
  }

  Future<void> sendFileMessage(
      {required context,
      required File file,
      required String receiverId,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required FirebaseStorages firebaseStorages,
      required MessageReply? messageReply,
      required bool isGroup}) async {
    try {
      var timesent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await firebaseStorages.uploadFile(file,
          'chats/${messageEnum.type}/${senderUserData.uid}/$receiverId/$messageId');

      UserModel? receiverUserModel;
      if (!isGroup) {
        var userData =
            await firebaseFirestore.collection("users").doc(receiverId).get();

        receiverUserModel = UserModel.fromJson(userData.data()!);
      }

      String messageType;

      switch (messageEnum) {
        case MessageEnum.image:
          messageType = "📷 Photo";
          break;

        case MessageEnum.video:
          messageType = "📸 Video";
          break;

        case MessageEnum.audio:
          messageType = "🎵 Audio";
          break;

        case MessageEnum.gif:
          messageType = "GIF";
          break;
        default:
          messageType = "GIF";
      }

      _saveDataToContactsSubCollection(senderUserData, receiverUserModel,
          messageType, timesent, receiverId, isGroup);

      _saveMessageToSubMessageCollection(
          receiverId: receiverId,
          text: imageUrl,
          timesent: timesent,
          messageId: messageId,
          username: senderUserData.name,
          messageType: messageEnum,
          messageReply: messageReply,
          senderUsername: senderUserData.name,
          receiverUserName: receiverUserModel?.name,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum,
          isGroup: isGroup);
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Future<void> sendGif({
    required context,
    required String receiverId,
    required UserModel senderData,
    required String url,
    required MessageReply? messageReply,
    required bool isGroup,
  }) async {
    try {
      var time = DateTime.now();
      UserModel? receiverData;
      if (!isGroup) {
        var usermap =
            await firebaseFirestore.collection("users").doc(receiverId).get();
        receiverData = UserModel.fromJson(usermap.data()!);
      }

      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderData,
        receiverData,
        "Gif",
        time,
        receiverId,
        isGroup,
      );
      _saveMessageToSubMessageCollection(
          receiverId: receiverId,
          text: url,
          timesent: time,
          messageId: messageId,
          username: senderData.name,
          messageType: MessageEnum.gif,
          messageReply: messageReply,
          senderUsername: senderData.name,
          receiverUserName: receiverData?.name,
          repliedMessageType: messageReply == null
              ? MessageEnum.text
              : messageReply.messageEnum,
          isGroup: isGroup);
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  void setChatMessageSeen(
      BuildContext context, String receiverId, String message) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(message)
          .update({"isSeen": true});

      await firebaseFirestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(message)
          .update({"isSeen": true});
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Stream<List<MessageModel>> getMessage(String groupId) {
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timesSent')
        .snapshots()
        .map((event) {
      List<MessageModel> message = [];
      for (var element in event.docs) {
        message.add(MessageModel.fromJson(element.data()));
      }
      return message;
    });
  }
}
