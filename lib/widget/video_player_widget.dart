import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isPlay = false;
  late CachedVideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  if (isPlay) {
                    videoPlayerController.pause();
                  } else {
                    videoPlayerController.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                icon: Icon(isPlay ? Icons.pause_circle : Icons.play_circle)),
          )
        ],
      ),
    );
  }
}
