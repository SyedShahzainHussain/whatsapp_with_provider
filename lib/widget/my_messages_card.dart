import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_app/enum/message_enum.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsapp_app/widget/video_player_widget.dart';

class MyMessages extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum replyMessageEnum;
  final bool isSeen;

  const MyMessages(
      {super.key,
      required this.message,
      required this.date,
      required this.messageEnum,
      required this.onLeftSwipe,
      required this.repliedText,
      required this.username,
      required this.replyMessageEnum,
      required this.isSeen});

  @override
  Widget build(BuildContext context) {
    final isReplied = repliedText.isNotEmpty;
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 45,
              ),
              child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: messageColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Stack(children: [
                    Padding(
                      padding: messageEnum == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 10,
                              right: 30,
                              bottom: 20,
                              top: 5,
                            )
                          : const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 25,
                              top: 5,
                            ),
                      child: Column(
                        children: [
                          if (isReplied) ...[
                            Text(username),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: backgroundColor.withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: replyMessageEnum == MessageEnum.text
                                  ? Text(repliedText,
                                      style: const TextStyle(fontSize: 16))
                                  : replyMessageEnum == MessageEnum.audio
                                      ? StatefulBuilder(
                                          builder: (context, setstate) {
                                          return IconButton(
                                              constraints: const BoxConstraints(
                                                  minWidth: 120),
                                              onPressed: () async {
                                                if (isPlaying) {
                                                  await audioPlayer.pause();
                                                  setstate(() {
                                                    isPlaying = false;
                                                  });
                                                } else {
                                                  await audioPlayer.play(
                                                      UrlSource(repliedText));
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
                                      : replyMessageEnum == MessageEnum.video
                                          ? VideoPlayer(videoUrl: repliedText)
                                          : messageEnum == MessageEnum.gif
                                              ? CachedNetworkImage(
                                                  imageUrl: repliedText)
                                              : CachedNetworkImage(
                                                  imageUrl: repliedText),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                          messageEnum == MessageEnum.text
                              ? Text(message,
                                  style: const TextStyle(fontSize: 16))
                              : messageEnum == MessageEnum.audio
                                  ? StatefulBuilder(
                                      builder: (context, setstate) {
                                      return IconButton(
                                          constraints: const BoxConstraints(
                                              minWidth: 120),
                                          onPressed: () async {
                                            if (isPlaying) {
                                              await audioPlayer.pause();
                                              setstate(() {
                                                isPlaying = false;
                                              });
                                            } else {
                                              await audioPlayer
                                                  .play(UrlSource(message));
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
                                  : messageEnum == MessageEnum.video
                                      ? VideoPlayer(videoUrl: message)
                                      : messageEnum == MessageEnum.gif
                                          ? CachedNetworkImage(
                                              imageUrl: message)
                                          : CachedNetworkImage(
                                              imageUrl: message),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 10,
                        child: Row(children: [
                          Text(date,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white60,
                              )),
                          const SizedBox(width: 5),
                          Icon(
                            isSeen ? Icons.done_all : Icons.done,
                            size: 20,
                            color: isSeen?Colors.blue: Colors.white60,
                          )
                        ]))
                  ])))),
    );
  }
}
