import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';

class OtpScreen extends StatelessWidget {
  final String verification;
  const OtpScreen({super.key, required this.verification});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Verifying your number"),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text("We have sent an SMS with a code."),
          SizedBox(
            width: width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const  InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    fontSize: 30,
                  )),
              onChanged: (val) {
                if (val.length == 6) {
                  context
                      .read<PhoneAuthViewModel>()
                      .verifyOtp(context, verification, val);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
