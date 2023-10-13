import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/features/status/viewModel/status_view_model.dart';

class ConfirmStatusScreen extends StatelessWidget {
  final File file;
  const ConfirmStatusScreen({super.key, required this.file});

  void getStatus(BuildContext context) {
    Provider.of<StatusViewModel>(context, listen: false).uploadStatus(context,file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getStatus(context);
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
