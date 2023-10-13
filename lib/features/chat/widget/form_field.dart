import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/chat/viewModel/chat_view_model.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/utils/utils.dart';
import 'package:whatsapp_app/widget/message_reply_widget.dart';

class InputFormFields extends StatefulWidget {
  TextEditingController controller;
  String receiverId;
  bool isGroup;
  InputFormFields({
    super.key,
    required this.controller,
    required this.receiverId,
    required this.isGroup,
  });

  @override
  State<InputFormFields> createState() => _InputFormFieldsState();
}

class _InputFormFieldsState extends State<InputFormFields> {
  bool isShowSendButton = false;
  bool isShowEmojiContainer = false;
  bool isRecorderInIt = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? recorder;
  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    recorder!.closeRecorder();
    isRecorderInIt = false;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Utils.showSnackBar(context, "Mic Permission denied");
    }
    await recorder!.openRecorder();
    isRecorderInIt = true;
  }

  void sendTextMessage() async {
    final userModel = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(userModel.data()!);
    if (isShowSendButton) {
      // ignore: use_build_context_synchronously
      context.read<ChatViewModel>().sendTextMessage(
            context,
            widget.controller.text.trim(),
            widget.receiverId,
            user,
            widget.isGroup,
          );
      setState(() {
        widget.controller.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      final path = "${tempDir.path}/flutter_sound.aac";
      if (!isRecorderInIt) {
        return;
      }
      if (isRecording) {
        await recorder!.stopRecorder();
        // ignore: use_build_context_synchronously
        context.read<ChatViewModel>().sendFileMessage(
            context,
            File(path),
            FirebaseStorages(firebaseStorage: FirebaseStorage.instance),
            MessageEnum.audio,
            widget.receiverId,
            user,
            widget.isGroup);
      } else {
        await recorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void selectedImage() async {
    final userModel = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(userModel.data()!);
    // ignore: use_build_context_synchronously
    File? image = await Utils.pickImageFromGallery(context);
    if (image != null) {
      // ignore: use_build_context_synchronously
      context.read<ChatViewModel>().sendFileMessage(
          context,
          image,
          FirebaseStorages(firebaseStorage: FirebaseStorage.instance),
          MessageEnum.image,
          widget.receiverId,
          user,
          widget.isGroup);
    }
  }

  void selectedVideo() async {
    final userModel = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(userModel.data()!);
    // ignore: use_build_context_synchronously
    File? video = await Utils.pickVideoFromGallery(context);
    if (video != null) {
      // ignore: use_build_context_synchronously
      context.read<ChatViewModel>().sendFileMessage(
          context,
          video,
          FirebaseStorages(firebaseStorage: FirebaseStorage.instance),
          MessageEnum.video,
          widget.receiverId,
          user,
          widget.isGroup);
    }
  }

  void seletedGif(BuildContext context) async {
    final userModel = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(userModel.data()!);
    final gif = await Utils.pickGIF(context);

    if (gif != null) {
      context.read<ChatViewModel>().sendGifMessage(
          context, gif.url, widget.receiverId, user, widget.isGroup);
    }
  }

  void hideEmojiContaienr() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContaienr() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContaienr();
    } else {
      hideKeyboard();
      showEmojiContaienr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MessageReplyWidget(),
        Row(
          children: [
            Expanded(
              child: TextField(
                  focusNode: focusNode,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  controller: widget.controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => toggleEmojiKeyboard(),
                                icon: const Icon(Icons.emoji_emotions,
                                    color: Colors.grey)),
                            IconButton(
                                onPressed: () => seletedGif(context),
                                icon:
                                    const Icon(Icons.gif, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: selectedImage,
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.grey)),
                            IconButton(
                                onPressed: selectedVideo,
                                icon: const Icon(Icons.attach_file,
                                    color: Colors.grey)),
                          ]),
                    ),
                    hintText: "Type a message ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 2, right: 2),
              child: CircleAvatar(
                backgroundColor: const Color(0xff128c73),
                radius: 25,
                child: InkWell(
                  onTap: () {
                    sendTextMessage();
                  },
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      widget.controller.text += emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
