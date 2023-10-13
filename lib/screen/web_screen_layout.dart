import 'package:flutter/material.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/widget/chat_list.dart';
import 'package:whatsapp_app/widget/contactList.dart';
import 'package:whatsapp_app/widget/web_chat_app.dart';
import 'package:whatsapp_app/widget/web_profile_bar.dart';
import 'package:whatsapp_app/widget/web_search_bar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const WebProfileBar(),
                WebSearchBar(),
                const ContactList()
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: dividerColor),
              ),
              image: DecorationImage(
                image: AssetImage(
                  "asset/backgroundImage.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              const WebChatApp(),
              const Expanded(
                  child: ChatList(
                recerverId: '',
                isGroup: false,
              )),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: dividerColor,
                        ),
                      ),
                      color: chatBarMessage),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        )),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: searchBarColor,
                          filled: true,
                          hintText: 'Type a messages',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        )),
                  ]))
            ]))
      ],
    ));
  }
}
