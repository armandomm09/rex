import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class FormDropdown extends StatefulWidget {
  final String title;
  final double fontSize;
  final List<String> listOfItems;
  final TextEditingController? controller;

  // Make onSaved optional with a null default value
  final Function(String)? onSaved;

  const FormDropdown({
    super.key,
    this.listOfItems = const ["Yes", "No"],
    required this.title,
    this.fontSize = 20,
    this.onSaved, this.controller,
  });

  @override
  _FormDropdownState createState() => _FormDropdownState();
}

class _FormDropdownState extends State<FormDropdown> {
  // ignore: unused_field
  String _selectedValue = ""; // Store the selected value

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    items = widget.listOfItems.map((item) => DropdownMenuItem(
      value: item,
      child: AppText(
        text: item,
        textColor: TextColor.red,
      ),
    )).toList();

    return Column(
      children: [
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          child: AppText(
            text: widget.title,
            textColor: TextColor.red,
            fontSize: widget.fontSize,
          ),
        ),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(8),
            focusColor: Theme.of(context).colorScheme.secondary,
            decoration: const InputDecoration(
              hintText: "Select value",
            ),
            items: items,
            //value: _selectedValue, // Set the initial value
            onChanged: (value) {
              setState(() {
                widget.controller?.text = value.toString();
                print("${widget.title}: ${value!}");
                _selectedValue = value; // Update state with selected value
              });
              // Call the onSaved callback with the selected value, but only if it's not null
              if (widget.onSaved != null) {
                widget.onSaved!(value!);
              }
            },
          ),
        ),
      ],
    );
  }
}
