import 'package:flutter/material.dart';

class prettyCounter extends StatefulWidget {
  const prettyCounter({super.key, this.controller});

  final TextEditingController? controller;

  @override
  State<prettyCounter> createState() => _prettyCounterState();
}

class _prettyCounterState extends State<prettyCounter> {
  // initialize counter:

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red)),
              onPressed: () {},
              child: Row(
                children: [
                  Icon(Icons.add),
                  Icon(Icons.minimize),
                ],
              )),
        ),
      ),
    );
  }
}
