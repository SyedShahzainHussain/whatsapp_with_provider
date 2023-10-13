import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/config/agora_congif.dart';
import 'package:whatsapp_app/features/call/model/call_model.dart';
import 'package:whatsapp_app/features/call/view_model.dart/call_view_model.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class CallScreen extends StatefulWidget {
  final String channedId;
  final CallModel callModel;
  final bool isGroup;
  const CallScreen({
    super.key,
    required this.channedId,
    required this.callModel,
    required this.isGroup,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? agoraClient;

  var token = 'http://localhost:8080/';

  @override
  void initState() {
    super.initState();
    agoraClient = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
      appId: AgoraConfig.appId,
      channelName: widget.channedId,
    ));
    initAgora();
  }

  void initAgora() async {
    await agoraClient!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: agoraClient == null
            ? const LoadingWidget()
            : SafeArea(
                child: Stack(
                children: [
                  AgoraVideoViewer(client: agoraClient!),
                  AgoraVideoButtons(
                    client: agoraClient!,
                    disconnectButtonChild: IconButton(
                        onPressed: () async {
                          if(widget.isGroup ){
                             await agoraClient!.engine.leaveChannel();
                          context.read<CallViewModel>().groupCallEnd(
                              widget.callModel,
                              context,
                              widget.callModel);
                          Navigator.pop(context);
                          }else{
                          await agoraClient!.engine.leaveChannel();
                          context.read<CallViewModel>().callEnd(
                              widget.callModel.callerId,
                              context,
                              widget.callModel.receiverId);
                          Navigator.pop(context);

                          }
                        },
                        icon: const Icon(Icons.call_end)),
                  ),
                ],
              )));
  }
}
