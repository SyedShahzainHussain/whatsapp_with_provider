import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/chat/viewModel/chat_view_model.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/utils/utils.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';
import 'package:whatsapp_app/widget/custom_button.dart';
import 'package:country_picker/country_picker.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _controller = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() async {
    final phoneNumber = _controller.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      context
          .read<PhoneAuthViewModel>()
          .loginInWithPhone('+${country!.phoneCode}$phoneNumber', context);
    } else {
      Utils.showSnackBar(context, "Please fill your credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Enter your phone number "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("WhatsApp will need to verify your phone number."),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () => pickCountry(),
              child: const Text("Pick Country"),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Phone Number",
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: CustomButton(
                  text: context.watch<PhoneAuthViewModel>().isLoading
                      ? "Loading"
                      : "NEXT",
                  onPressed: () {
                    sendPhoneNumber();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
