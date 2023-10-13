import 'package:flutter/material.dart';
import 'package:whatsapp_app/resources/colors.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.25,
      height: MediaQuery.sizeOf(context).height * 0.06,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search or start new chat.",
            fillColor: searchBarColor,
            filled: true,
            hintStyle: const TextStyle(fontSize: 14),
            prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.search,
                  size: 20,
                )),
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ))),
      ),
    );
  }
}
