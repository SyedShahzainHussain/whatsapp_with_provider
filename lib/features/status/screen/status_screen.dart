import 'package:flutter/material.dart';

import 'package:story_view/story_view.dart';
import 'package:whatsapp_app/model/status_model.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class StatusScreen extends StatefulWidget {
  final StatusModel statusModel;
  const StatusScreen({super.key, required this.statusModel});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItem = [];

  @override
  void initState() {
    super.initState();
    iniitStory();
  }

  iniitStory() {
    for (int i = 0; i < widget.statusModel.photosurl.length; i++) {
      storyItem.add(StoryItem.pageImage(
          url: widget.statusModel.photosurl[i], controller: storyController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItem.isEmpty
          ? const LoadingWidget()
          : StoryView(
              storyItems: storyItem,
              controller: storyController,  
              onVerticalSwipeComplete: (direction){
                if(direction == Direction.down || direction == Direction.right ){
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
