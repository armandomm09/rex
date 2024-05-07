import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(
              width: 20,
            ),
            AppText(
              text: text,
              textColor: TextColor.red,
            ),
          ],
        ),
      ),
    );
  }
}