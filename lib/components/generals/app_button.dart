import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final double height;
  final double width;
  final String text;
  
  const AppButton({super.key, 
      required this.text, 
      required this.onTap, this.height = 80, this.width = 200
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: AppText(text: text),
        ),
      ),
    );
  }
}
