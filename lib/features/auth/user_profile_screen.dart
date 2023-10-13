import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/utils/utils.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? image;
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void selectedIamge() async {
    image = await Utils.pickImageFromGallery(context);
    setState(() {});
  }

  void storeUseData() async {
    String name = controller.text.trim();
    if (name.isNotEmpty) {
      context
          .read<PhoneAuthViewModel>()
          .storeDataToFirebase(context, image!, name);
    } else {
      Utils.showSnackBar(context, "Enter the name");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(children: [
          Stack(
            children: [
              image == null
                  ? const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80'),
                      radius: 64,
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 64,
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: () {
                    selectedIamge();
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: width.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(hintText: "Enter your name"),
                ),
              ),
              IconButton(
                onPressed: () {
                  storeUseData();
                },
                icon: const Icon(Icons.done),
              ),
            ],
          )
        ]),
      )),
    );
  }
}
