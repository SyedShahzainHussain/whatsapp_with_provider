import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_app/model/user_model.dart';

import 'package:whatsapp_app/repository/phone_auth.dart';
import 'package:whatsapp_app/utils/utils.dart';

class PhoneAuthViewModel with ChangeNotifier {
  final PhoneRepository phoneRepository =
      PhoneRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void loginInWithPhone(String phoneNumber, BuildContext context) {
    setLoading(true);
    phoneRepository.signinWithPhone(phoneNumber, context).then((value) {
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showSnackBar(context, error.toString());
    });
  }

  void verifyOtp(BuildContext context, String verifyId, String otp) async {
    phoneRepository
        .verifyOtp(context, verifyId, otp)
        .onError((error, stackTrace) {
      Utils.showSnackBar(context, error.toString());
    });
  }

  void storeDataToFirebase(
      BuildContext context, File profilePic, String name) async {
    phoneRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, context: context);
  }

  Future<UserModel?> getUserData() async {
    UserModel? userModel = await phoneRepository.getCurrentUserData();
    return userModel;
  }

  Stream<UserModel> getUserBuId(String uid) {
    return phoneRepository.userDataById(uid);
  }

  void setUserState(bool isOnline) {
    phoneRepository.setUserState(isOnline);
  }

  void logout(BuildContext context) {
    phoneRepository.logout(context);
  }
}
