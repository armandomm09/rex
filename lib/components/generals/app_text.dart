import 'dart:ui';

import 'package:flutter/material.dart';

enum TextColor {
  red, black, gray, blueAlliance, redAlliance
}

class AppText extends StatelessWidget {
  final String text;
  final TextColor textColor;
  final double fontSize;
  const AppText({super.key, required this.text, this.textColor = TextColor.black, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {

    getColor(){
    if(textColor == TextColor.red){
      return Theme.of(context).colorScheme.inversePrimary;
    } else if(textColor == TextColor.black){
      return Theme.of(context).colorScheme.background;
    } else if(textColor == TextColor.gray){
      return Theme.of(context).colorScheme.secondary;
    } else if(textColor == TextColor.blueAlliance){
      return Color.fromARGB(255, 31, 49, 151);
    } else if(textColor == TextColor.redAlliance){
      return Color.fromARGB(255, 220, 8, 8);
    }
  }
    return Text(
                text,
                //selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
                style: TextStyle(
                    color: getColor(),
                    fontSize: fontSize,
                    fontFamily: "Industry",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              );
  }

  getTextStyle(TextColor color, BuildContext context){
    var colorForText;
    if(color == TextColor.red){
      colorForText = Theme.of(context).colorScheme.inversePrimary;
    } else {
      colorForText = Theme.of(context).colorScheme.background;
    }
    return TextStyle(
                    color: colorForText ,
                    fontSize: fontSize,
                    fontFamily: "Industry",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic);
  }
}