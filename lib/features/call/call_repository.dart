import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_app/features/call/model/call_model.dart';
import 'package:whatsapp_app/features/call/screen/call_screen.dart';
import 'package:whatsapp_app/features/group/model/groupModel.dart';
import 'package:whatsapp_app/utils/utils.dart';

class CallRepository {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth auth;
  CallRepository({required this.firebaseFirestore, required this.auth});

  void makeCall(
    CallModel senderCallData,
    BuildContext context,
    CallModel receiverCallData,
    bool isGroupChat,
  ) async {
    try {
      await firebaseFirestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());

      await firebaseFirestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toJson());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                    callModel: senderCallData,
                    channedId: senderCallData.callId,
                    isGroup: false,
                  )));
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Stream<DocumentSnapshot> get getCall => firebaseFirestore
      .collection('call')
      .doc(auth.currentUser!.uid)
      .snapshots();

  Future<void> callEnd(
      String callerId, BuildContext context, String receiverId) async {
    await firebaseFirestore.collection('call').doc(callerId).delete();
    await firebaseFirestore.collection('call').doc(receiverId).delete();
  }

  Future<void> makeGroupCall(CallModel senderData, BuildContext context,
      CallModel receiverData) async {
    await firebaseFirestore
        .collection('call')
        .doc(senderData.callerId)
        .set(senderData.toJson());

    var groupSnapShot = await firebaseFirestore
        .collection('groups')
        .doc(senderData.receiverId)
        .get();

    GroupModel groupModel = GroupModel.fromJson(groupSnapShot.data()!);
    for (var id in groupModel.memberId) {
      await firebaseFirestore
          .collection('call')
          .doc(id)
          .set(receiverData.toJson());
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallScreen(
                channedId: senderData.callerId,
                callModel: senderData,
                isGroup: true)));
  }

  void groupCallEnd(CallModel senderUserModel, CallModel receiverCallData,
      BuildContext context) async {
    await firebaseFirestore
        .collection('call')
        .doc(senderUserModel.callerId)
        .delete();

    var groupSnapShot = await firebaseFirestore
        .collection('groups')
        .doc(senderUserModel.receiverId)
        .get();

    GroupModel groupModel = GroupModel.fromJson(groupSnapShot.data()!);
    for (var id in groupModel.memberId) {
      await firebaseFirestore.collection('call').doc(id).delete();
    }
  }
}
