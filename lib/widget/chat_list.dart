import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/chat/viewModel/chat_view_model.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/model/message.dart';
import 'package:whatsapp_app/provider/message_reply.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';
import 'package:whatsapp_app/widget/my_messages_card.dart';
import 'package:whatsapp_app/widget/sender_messages.dart';

class ChatList extends StatefulWidget {
  final String recerverId;
  final bool isGroup;
  const ChatList({super.key, required this.recerverId, required this.isGroup});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    context
        .read<MessageReplyProvider>()
        .setMessageReply(MessageReply(message, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: widget.isGroup
            ? context.read<ChatViewModel>().getGroupMessages(widget.recerverId)
            : context
                .read<ChatViewModel>()
                .getMessageContacts(widget.recerverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var timeSent =
                    DateFormat.Hm().format(snapshot.data![index].timesSent);

                if (!snapshot.data![index].isSeen &&
                    snapshot.data![index].receiverId ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  context.watch<ChatViewModel>().setChatMessageSeen(
                        context,
                        widget.recerverId,
                        snapshot.data![index].messageId,
                      );
                }
                if (snapshot.data![index].senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessages(
                      message: snapshot.data![index].text,
                      date: timeSent,
                      messageEnum: snapshot.data![index].messageType,
                      repliedText: snapshot.data![index].repliedMessage,
                      replyMessageEnum:
                          snapshot.data![index].repliedMessageType,
                      username: snapshot.data![index].repliedTo,
                      onLeftSwipe: () => onMessageSwipe(
                          snapshot.data![index].text,
                          true,
                          snapshot.data![index].messageType),
                      isSeen: snapshot.data![index].isSeen);
                }
                return SenderMessages(
                  message: snapshot.data![index].text,
                  date: timeSent,
                  messageEnum: snapshot.data![index].messageType,
                  repliedText: snapshot.data![index].repliedMessage,
                  replyMessageEnum: snapshot.data![index].repliedMessageType,
                  username: snapshot.data![index].repliedTo,
                  onLeftSwipe: () => onMessageSwipe(snapshot.data![index].text,
                      false, snapshot.data![index].messageType),
                );
              });
        });
  }
}
