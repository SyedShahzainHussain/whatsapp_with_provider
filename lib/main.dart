import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/call/view_model.dart/call_view_model.dart';
import 'package:whatsapp_app/features/chat/viewModel/chat_view_model.dart';
import 'package:whatsapp_app/features/landing/landing.dart';
import 'package:whatsapp_app/firebase_options.dart';
import 'package:whatsapp_app/provider/message_reply.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/features/group/viewModel/contact_view_model.dart';
import 'package:whatsapp_app/screen/mobile_screen_layout.dart';
import 'package:whatsapp_app/features/status/viewModel/status_view_model.dart';
import 'package:whatsapp_app/utils/routes/routes.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';
import 'package:whatsapp_app/viewModel/selected_contact_view_model.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => PhoneAuthViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => SelectedContactViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => MessageReplyProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => StatusViewModel(),
    ),
     ChangeNotifierProvider
     (
      create: (context) => ContactViewModel(),
    ),
      ChangeNotifierProvider(
      create: (context) => CallViewModel(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: appBarColor,
          )),
      home: FutureBuilder(
        future: context.watch<PhoneAuthViewModel>().getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return const MobileScreenLayout();
            } else {
              return const LandingScreen();
            }
          } else {
            return const LoadingWidget();
          }
        },
      ),
      onGenerateRoute: Routes().onGenericRoute,
    );
  }
}
