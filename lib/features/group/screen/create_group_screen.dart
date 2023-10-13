import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/features/group/screen/selected_Contact_group.dart';
import 'package:whatsapp_app/features/group/viewModel/contact_view_model.dart';
import 'package:whatsapp_app/utils/utils.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  void createGroups() {
    if (groupController.text.trim().isNotEmpty && image != null) {
      Utils.showSnackBar(context, "Creating group...");
      context
          .read<ContactViewModel>()
          .createGroup(
            context,
            groupController.text.trim(),
            image!,
            context.read<ContactViewModel>().selectedContacts,
          )
          .then((value) {
        context.read<ContactViewModel>().clearSelectedContacts();
        context.read<ContactViewModel>().clearSelectedContact();
        Navigator.pop(context);
      });
    } else {
      Utils.showSnackBar(context, 'Required');
    }
  }

  File? image;
  final TextEditingController groupController = TextEditingController();

  void selectedImage() async {
    image = await Utils.pickImageFromGallery(context);
    setState(() {});
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   groupController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              image == null
                  ? const CircleAvatar(
                      backgroundImage: NetworkImage(''),
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
                    selectedImage();
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: groupController,
              decoration: const InputDecoration(hintText: "Enter Group Name"),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Selected Contacts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Expanded(child: const SelectedContactGroup())
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroups();
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
