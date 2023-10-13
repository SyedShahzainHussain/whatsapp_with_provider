import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/screen/mobile_screen_layout.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/utils/utils.dart';

class PhoneRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  PhoneRepository(this.auth, this.firestore);

  Future<void> signinWithPhone(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential cred) async {
            await auth.signInWithCredential(cred);
          },
          verificationFailed: (e) {
            throw Exception(e.message!);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.pushNamed(context, RouteName.otpScreen,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> verifyOtp(context, String verificationId, String otpCode) async {
    try {
      final PhoneAuthCredential phone = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      await auth.signInWithCredential(phone);
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.userField, (route) => false);
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Future<void> saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photosUrl =
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80';

      if (profilePic != null) {
        photosUrl =
            await FirebaseStorages(firebaseStorage: FirebaseStorage.instance)
                .uploadFile(
          profilePic,
          "ProfilePic/$uid",
        );
      }
      final UserModel user = UserModel(
        name: name,
        photosUrl: photosUrl,
        phoneNumber: auth.currentUser!.phoneNumber!,
        isOnline: true,
        groupId: [],
        uid: uid,
      );
      await firestore.collection('users').doc(uid).set(user.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
          (route) => false);
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();

    UserModel? userModel;
    if (userData.data() != null) {
      userModel = UserModel.fromJson(userData.data()!);
    }
    return userModel;
  }

  Stream<UserModel> userDataById(String uid) {
    return firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Future<void> setUserState(bool isOnline) async {
    firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"isOnline": isOnline});
  }
}
