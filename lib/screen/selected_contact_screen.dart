import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/viewModel/selected_contact_view_model.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class SelectedContactScreen extends StatelessWidget {
  const SelectedContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
          future: context.watch<SelectedContactViewModel>().getContact(),
          builder: ((context, AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                          onTap: () {
                            context
                                .read<SelectedContactViewModel>()
                                .selectedContact(
                                    context, snapshot.data![index]);
                          },
                          title: Text(snapshot.data![index].displayName),
                          leading: snapshot.data![index].photo == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(snapshot.data![index].photo!),
                                  radius: 30,
                                )),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              } else {
                return const Text("Did'nt find contact");
              }
            } else {
              return const LoadingWidget();
            }
          })),
    );
  }
}
