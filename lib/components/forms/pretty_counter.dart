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
            child: Container(
      width: 102,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.red,
      ),
      child: Row(
        children: [
          MaterialButton(
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              minWidth: 3,
              onPressed: () {},
              child: Text(
                '-',
                style: TextStyle(color: Colors.white, fontSize: 35),
              )),
          MaterialButton(
              minWidth: 3,
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              onPressed: () {},
              child: Text(
                '+',
                style: TextStyle(color: Colors.white, fontSize: 30),
              )),
        ],
      ),
    )));
  }
}
