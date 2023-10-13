import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/chat/model/chat_contact_model.dart';
import 'package:whatsapp_app/features/chat/viewModel/chat_view_model.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/features/group/model/groupModel.dart';
import 'package:whatsapp_app/features/group/viewModel/contact_view_model.dart';

import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<GroupModel>>(
                stream: context.watch<ContactViewModel>().getGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading",style: TextStyle(color: Colors.white),);
                  } else if (!snapshot.hasData && snapshot.data!.isEmpty) {
                    return const SizedBox();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.chatScreen, arguments: {
                                "name": snapshot.data![index].name,
                                "uid": snapshot.data![index].groupId,
                                "image": snapshot.data![index].groupPicture,
                                'isGroup': true,
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].name.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    snapshot.data![index].lastMessage
                                        .toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index].groupPicture,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(snapshot.data![index].timestamp),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
            StreamBuilder<List<ChatContactModel>>(
                stream: context.watch<ChatViewModel>().getChatContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading",style: TextStyle(color: Colors.white),);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.chatScreen, arguments: {
                                "name": snapshot.data![index].name,
                                "uid": snapshot.data![index].contactId,
                                "image": snapshot.data![index].profilePic,
                                'isGroup': false,
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].name.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    snapshot.data![index].lastMessage
                                        .toString(),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index].profilePic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(snapshot.data![index].dateTime!),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: dividerColor, indent: 85),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
