import 'package:flutter/material.dart';

class prettyCounter extends StatefulWidget {
  final String title;
  final TextEditingController? controller;

  const prettyCounter({
    super.key,
    this.controller,
    required this.title,
  });

  @override
  State<prettyCounter> createState() => _prettyCounterState();
}

class _prettyCounterState extends State<prettyCounter> {
  // initialize counter:

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(height: 20),
        Container(
          width: 102,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.red,
          ),
          child: Row(
            children: [
              MaterialButton(
                  shape:
                      CircleBorder(side: BorderSide(color: Colors.transparent)),
                  minWidth: 3,
                  onPressed: () {
                    setState(() {
                      if (counter > 0) {
                        counter -= 1;
                        widget.controller?.text = counter.toString();
                        print(widget.controller?.text);
                      }
                    });
                  },
                  child: Text(
                    '-',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  )),
              Text('holis'),
              MaterialButton(
                  minWidth: 3,
                  shape:
                      CircleBorder(side: BorderSide(color: Colors.transparent)),
                  onPressed: () {
                    setState(() {
                      counter += 1;
                      widget.controller?.text = counter.toString();
                      print(widget.controller?.text);
                    });
                  },
                  child: Text(
                    '+',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
