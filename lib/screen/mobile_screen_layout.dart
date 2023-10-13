import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_app/resources/colors.dart';
import 'package:whatsapp_app/features/status/screen/statuc_contact_screen.dart';
import 'package:whatsapp_app/utils/routes/route_name.dart';
import 'package:whatsapp_app/utils/utils.dart';
import 'package:whatsapp_app/viewModel/phone_auth_view_model.dart';
import 'package:whatsapp_app/widget/contactList.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<PhoneAuthViewModel>().setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        context.read<PhoneAuthViewModel>().setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: appBarColor,
          title: const Text(
            "WhatsApp",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text("Create Group"),
                        onTap: () => Future(
                          () => Navigator.pushNamed(
                            context,
                            RouteName.createGroup,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: const Text("Logout"),
                        onTap: () => Future(() {
                          context.read<PhoneAuthViewModel>().logout(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteName.landingScreen,
                            (route) => false,
                          );
                        }),
                      ),
                    ]),
          ],
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: tabColor,
              indicatorWeight: 4,
              labelColor: tabColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(
                  text: "Chats",
                ),
                Tab(
                  text: "Status",
                ),
                Tab(
                  text: "Calls",
                ),
              ]),
        ),
        body: TabBarView(controller: _tabController, children: [
          ContactList(),
          StatusContactScreen(),
          StatusContactScreen(),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_tabController.index == 0) {
                Navigator.pushNamed(context, RouteName.selectedContact);
              } else {
                File? pickedImage = await Utils.pickImageFromGallery(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(context, RouteName.statusConfirmScreen,
                      arguments: pickedImage);
                }
              }
            },
            backgroundColor: tabColor,
            child: _tabController.index == 0
                ? const Icon(
                    Icons.comment,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.camera,
                    color: Colors.white,
                  )),
      ),
    );
  }
}
