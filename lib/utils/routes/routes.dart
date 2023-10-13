import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_app/features/landing/landing.dart';
import 'package:whatsapp_app/model/status_model.dart';
import 'package:whatsapp_app/features/auth/otp_screen.dart';
import 'package:whatsapp_app/features/auth/phone_auth_screen.dart';
import 'package:whatsapp_app/features/auth/user_profile_screen.dart';
import 'package:whatsapp_app/features/group/screen/create_group_screen.dart';
import 'package:whatsapp_app/screen/mobile_chat_screen.dart';
import 'package:whatsapp_app/screen/selected_contact_screen.dart';
import 'package:whatsapp_app/features/status/screen/confirm_status_screen.dart';
import 'package:whatsapp_app/features/status/screen/statuc_contact_screen.dart';
import 'package:whatsapp_app/features/status/screen/status_screen.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';

class Routes {
  Route<dynamic> onGenericRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteName.phoneScreen:
        return MaterialPageRoute(builder: (context) => const PhoneAuthScreen());
      case RouteName.landingScreen:
        return MaterialPageRoute(builder: (context) => const LandingScreen());
      case RouteName.userField:
        return MaterialPageRoute(
            builder: (context) => const UserProfileScreen());
      case RouteName.selectedContact:
        return MaterialPageRoute(
            builder: (context) => const SelectedContactScreen());
      case RouteName.chatScreen:
        final snap = setting.arguments as dynamic;
        return MaterialPageRoute(
            builder: (context) => MobileChatScreen(
                  infos: snap,
                ));
      case RouteName.otpScreen:
        final verification = setting.arguments as String;
        return MaterialPageRoute(
            builder: (context) => OtpScreen(
                  verification: verification,
                ));
      case RouteName.statusContactScreen:
        return MaterialPageRoute(
            builder: (context) => const StatusContactScreen());
      case RouteName.statusScreen:
        final status = setting.arguments as StatusModel;
        return MaterialPageRoute(
            builder: (context) => StatusScreen(
                  statusModel: status,
                ));
      case RouteName.statusConfirmScreen:
        final file = setting.arguments as File;
        return MaterialPageRoute(
            builder: (context) => ConfirmStatusScreen(file: file));
      case RouteName.createGroup:
        return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                    body: Center(
                  child: Text('404'),
                )));
    }
  }
}
