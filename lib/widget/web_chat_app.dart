import 'package:flutter/material.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/resources/info.dart';

class WebChatApp extends StatelessWidget {
  const WebChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.077,
        width: MediaQuery.sizeOf(context).width * 0.75,
        padding: const EdgeInsets.all(10),
        color: webAppBarColor,
        child: Row(children: [
          const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg')),
          const SizedBox(width: 15),
          Text(info[0]['name'].toString(),
              style: const TextStyle(
                fontSize: 18,
              )),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.grey)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.grey))
        ]));
  }
}
