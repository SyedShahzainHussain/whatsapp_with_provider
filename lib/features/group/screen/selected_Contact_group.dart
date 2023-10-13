import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/features/group/viewModel/contact_view_model.dart';
import 'package:whatsapp_app/viewModel/selected_contact_view_model.dart';
import 'package:whatsapp_app/widget/loading_widget.dart';

class SelectedContactGroup extends StatefulWidget {
  const SelectedContactGroup({super.key});

  @override
  State<SelectedContactGroup> createState() => _SelectedContactGroupState();
}

class _SelectedContactGroupState extends State<SelectedContactGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Contact>>(
          future: context.watch<SelectedContactViewModel>().getContact(),
          builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                        onTap: () {
                          context
                              .read<ContactViewModel>()
                              .selectedContacted(index, snapshot.data![index]);
                        },
                        title: Text(
                          snapshot.data![index].displayName,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: Consumer<ContactViewModel>(
                          builder: (context, value, child) {
                            return value.selectedContact.contains(index)
                                ? IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.done))
                                : const SizedBox();
                          },
                        )),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          }),
    );
  }
}
