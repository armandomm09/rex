import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget {
  final String text;
  const MyAppbar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
            elevation: 50,
            toolbarHeight: 70,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 28,
                  fontFamily: "Industry",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ));
  }
}