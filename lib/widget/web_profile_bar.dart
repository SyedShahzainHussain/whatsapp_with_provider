import 'package:flutter/material.dart';
import 'package:whatsapp_app/resources/colors.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.25,
      height: MediaQuery.sizeOf(context).height * 0.077,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: dividerColor)),
          color: webAppBarColor),
      child: Row(children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              'https://www.socialketchup.in/wp-content/uploads/2020/05/fi-vill-JOHN-DOE.jpg'),
        ),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.comment,
              color: Colors.grey,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ))
      ]),
    );
  }
}
