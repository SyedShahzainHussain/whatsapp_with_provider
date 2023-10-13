import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_app/features/call/call_repository.dart';
import 'package:whatsapp_app/features/call/model/call_model.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';

class CallViewModel with ChangeNotifier {
  CallRepository callRepository = CallRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);

  void makeCall(BuildContext context, String receiverId, String receiverName,
      String receiverPicture, bool isGroup) async {
    UserModel? user = await context.read<PhoneAuthViewModel>().getUserData();
    if (user != null) {
      String callId = const Uuid().v1();
      CallModel senderCallData = CallModel(
          callerId: user.uid,
          callerName: user.name,
          callerPicture: user.photosUrl,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPicture: receiverPicture,
          callId: callId,
          hasDialled: true);
      CallModel receiverCallData = CallModel(
          callerId: user.uid,
          callerName: user.name,
          callerPicture: user.photosUrl,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPicture: receiverPicture,
          callId: callId,
          hasDialled: false);
      if (isGroup) {
        callRepository.makeGroupCall(senderCallData, context, receiverCallData);
      } else {
        callRepository.makeCall(
            senderCallData, context, receiverCallData, isGroup);
      }
    }
  }

  Stream<DocumentSnapshot> get getCall => callRepository.getCall;

  void callEnd(String callerId, BuildContext context, String receiverId) async {
    await callRepository.callEnd(callerId, context, receiverId);
  }

  void groupCallEnd(CallModel senderUserModel, BuildContext context,
      CallModel receiverCallData) async {
    callRepository.groupCallEnd(senderUserModel, receiverCallData, context);
  }
}
