import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';

class Utils {
  static void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: appBarColor,
    ));
  }

  static Future<File?> pickImageFromGallery(context) async {
    File? image;
    try {
      final pickedIamge =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedIamge != null) {
        image = File(pickedIamge.path);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return image;
  }

  static Future<File?> pickVideoFromGallery(context) async {
    File? video;
    try {
      final pickedIamge =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedIamge != null) {
        video = File(pickedIamge.path);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return video;
  }

  static Future<GiphyGif?> pickGIF(context) async {
    GiphyGif? giphy;
    try {
      giphy = await Giphy.getGif(
        
          context: context, apiKey: '8jyI7Xn2tOJAugvHvCF0Etmq6pFel0fg');

    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return giphy;
  }
}
