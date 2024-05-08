import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final double width;
  final TextEditingController controller;
  final onChanged;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  const AppTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      this.onChanged,
      this.width = 350, this.focusNode, this.onSubmitted });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
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
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    );
  }
}
