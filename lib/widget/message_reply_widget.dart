import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/provider/message_reply.dart';
import 'package:whatsapp_app/widget/video_player_widget.dart';

class MessageReplyWidget extends StatelessWidget {
  const MessageReplyWidget({super.key});

  void cancelReply(MessageReplyProvider provider) {
    provider.setMessageReply(null);
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();
    bool isPlaying = false;
    final data = context.watch<MessageReplyProvider?>();
    return data!.messageReply != null
        ? Container(
            width: 350,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.messageReply!.isMe ? "Me" : "Opposite",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cancelReply(data);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                data.messageReply!.messageEnum == MessageEnum.text
                    ? Text(data.messageReply!.message,
                        style: const TextStyle(fontSize: 16))
                    : data.messageReply!.messageEnum == MessageEnum.audio
                        ? StatefulBuilder(builder: (context, setstate) {
                            return IconButton(
                                constraints:
                                    const BoxConstraints(minWidth: 120),
                                onPressed: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                    setstate(() {
                                      isPlaying = false;
                                    });
                                  } else {
                                    await audioPlayer.play(UrlSource(
                                      data.messageReply!.message,
                                    ));
                                    setstate(() {
                                      isPlaying = true;
                                    });
                                  }
                                },
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                ));
                          })
                        : data.messageReply!.messageEnum == MessageEnum.video
                            ? VideoPlayer(
                                videoUrl: data.messageReply!.message,
                              )
                            : data.messageReply!.messageEnum == MessageEnum.gif
                                ? CachedNetworkImage(
                                  height: 200,
                                    imageUrl: data.messageReply!.message,
                                  )
                                : CachedNetworkImage(
                                       height: 200,
                                    imageUrl: data.messageReply!.message,
                                  ),
              ],
            ),
          )
        : const SizedBox();
  }
}
