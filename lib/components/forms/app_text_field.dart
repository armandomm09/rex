import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final double width;
  final double? height;
  final TextEditingController controller;
  final onChanged;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final EdgeInsetsGeometry? padding;
  const AppTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      this.onChanged,
      this.width = 350, this.focusNode, this.onSubmitted, this.height, this.padding = const EdgeInsets.symmetric(horizontal: 25)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: padding!,
        child: TextField(
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontFamily: "Industry",
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          onChanged: onChanged,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    ).animate().fadeIn();
  }
}
