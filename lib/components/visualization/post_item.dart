import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String user;
  const PostItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset("/Users/Armando09/DART/chat_app/assets/images/bumpy.JPG"),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(text: "5887"),
              AppText(text: "-$user"),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const AppText(
              text:
                  "arning: In index.html:37: Local variable for is deprecated. Use  template token instead."),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [AppText(text: "Imperator")],
          )
        ]));
  }
}
