import 'package:flutter/material.dart';

class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 0, bottom: 20),
          child: Image.asset(
            "assets/images/5887_trans.png", 
            height:50,
            //width: 30,
            //fit: BoxFit.cover,
            ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8),
          child: CircularProgressIndicator(strokeWidth: 5, strokeAlign: 9, color: Theme.of(context).colorScheme.inversePrimary,))
      ],),
    );
  }
}