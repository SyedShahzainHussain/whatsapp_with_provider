import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/call/model/call_model.dart';
import 'package:whatsapp_app/features/call/screen/call_screen.dart';
import 'package:whatsapp_app/features/call/view_model.dart/call_view_model.dart';

class CallPickUpScreen extends StatelessWidget {
  final Widget scaffold;
  const CallPickUpScreen({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: context.watch<CallViewModel>().getCall,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            CallModel call = CallModel.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDialled) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Incoming Call",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      const SizedBox(height: 50),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPicture),
                        radius: 60,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call_end,
                                color: Colors.redAccent,
                              )),
                          const SizedBox(width: 25),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CallScreen(
                                              callModel: call,
                                              channedId: call.callId,
                                              isGroup: false,
                                            )));
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }
          return scaffold;
        });
  }
}
