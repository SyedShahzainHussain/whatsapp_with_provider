import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_app/firebase/firebase_storage.dart';
import 'package:whatsapp_app/model/status_model.dart';
import 'package:whatsapp_app/features/status/repository/status_repository.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class StatusContactScreen extends StatelessWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StatusRepository statusRepository = StatusRepository(
        auth: FirebaseAuth.instance,
        firebaseStorage:
            FirebaseStorages(firebaseStorage: FirebaseStorage.instance),
        firestore: FirebaseFirestore.instance);
    return Scaffold(
      body: FutureBuilder<List<StatusModel>>(
        future: statusRepository.getStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.statusScreen,
                        arguments: snapshot.data![index]);
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(snapshot.data![index].profilePic),
                  ),
                  title: Text(snapshot.data![index].username),
                );
              },
            );
          } else {
            // Handle the case when there's no data to display
            return Text(snapshot.error.toString());
          }
        },
      ),
    );
  }
}
