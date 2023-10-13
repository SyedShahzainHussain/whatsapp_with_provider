import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/call/screen/call_pickup_screen.dart';
import 'package:whatsapp_app/features/call/view_model.dart/call_view_model.dart';
import 'package:whatsapp_app/features/chat/widget/form_field.dart';
import 'package:whatsapp_app/model/user_model.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';
import 'package:whatsapp_app/widget/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  final infos;
  const MobileChatScreen({super.key, required this.infos});

  @override
  Widget build(BuildContext context) {
    void makCall(BuildContext context, String receiverId, String receiverName,
        String receiverPicture) {
      context.read<CallViewModel>().makeCall(
          context, receiverId, receiverName, receiverPicture, infos['isGroup']);
    }

    TextEditingController messageController = TextEditingController();
    return CallPickUpScreen(

      scaffold: Scaffold(
          appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Expanded(
                      flex:
                          1, // Adjust the flex value as needed for relative sizing
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex:
                          2, // Adjust the flex value as needed for relative sizing
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(infos["image"]),
                        radius: 20,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: appBarColor,
              title: infos['isGroup']
                  ? Text(infos['name'])
                  : StreamBuilder<UserModel>(
                      stream: context
                          .watch<PhoneAuthViewModel>()
                          .getUserBuId(infos['uid']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.name,
                            ),
                            Text(
                              snapshot.data!.isOnline ? "Online" : "Offline",
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        );
                      }),
              actions: [
                IconButton(
                    onPressed: () {
                      makCall(
                          context, infos['uid'], infos['name'], infos['image']);
                    },
                    icon: const Icon(Icons.video_call)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ]),
          body: Column(children: [
            Expanded(
                child: ChatList(
              recerverId: infos['uid'],
              isGroup: infos['isGroup'],
            )),
            InputFormFields(
              controller: messageController,
              receiverId: infos['uid'],
              isGroup: infos['isGroup'],
            )
          ])),
    );
  }
}
