import 'package:flutter/material.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/widget/custom_button.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                 Text("Welcome to WhatsApp",

                    style: TextStyle(
                      fontSize: sized.width *0.080,
                      fontWeight: FontWeight.w600,
                    )),
                const Spacer(),
                Image.asset(
                  "asset/bg.png",
                  width: 340,
                  height: 340,
                  color: tabColor,
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Read our Privacy Policy. Tap  'Agree and Continue' to accept the terms of service",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: greyColor),
                  ),
                ),
                SizedBox(
                  width: sized.width * 0.75,
                  child: CustomButton(
                      text: "Agree and Continue",
                      onPressed: () {
                        Navigator.pushNamed(context, RouteName.phoneScreen);
                      }),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
