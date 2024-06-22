import 'package:flutter/material.dart';

enum TextColor { red, black, gray, blueAlliance, redAlliance, base }

class AppText extends StatelessWidget {
  final String text;
  final TextColor textColor;
  final double fontSize;

  //final bool title;
  const AppText({
    super.key,
    required this.text,
    this.textColor = TextColor.black,
    this.fontSize = 18,
    //required this.title,

    //required this.font});
  });

  
  getColor(BuildContext context) {
    if (textColor == TextColor.red) {
      return Theme.of(context).colorScheme.inversePrimary;
    } else if (textColor == TextColor.black) {
      return Theme.of(context).colorScheme.surface;
    } else if (textColor == TextColor.gray) {
      return Theme.of(context).colorScheme.secondary;
    } else if (textColor == TextColor.blueAlliance) {
      return const Color.fromARGB(255, 31, 49, 151);
    } else if (textColor == TextColor.redAlliance) {
      return const Color.fromARGB(255, 220, 8, 8);
    } else if (textColor == TextColor.base) {
      return const Color.fromARGB(255, 255, 255, 255);
    }
  }
  

  // getColor(BuildContext context) {
  //   if (fontSize == 20) {
  //     return const Color.fromARGB(255, 255, 255, 255);
  //   } else if (textColor == TextColor.black) {
  //     return const Color.fromARGB(0, 0, 0, 0);
  //   } else if (textColor == TextColor.red) {
  //     return const Color.fromARGB(255, 218, 30, 30);
  //   }
  // }

  getFont(BuildContext context) {
    if (fontSize == 20) {
      return "Inter";
    } else {
      return "Industry";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      text,
      //selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
      style: TextStyle(
          color: getColor(context),
          fontSize: fontSize,
          fontFamily: getFont(
            context,
          )),
    );
  }

  // getTextStyle(TextColor color, BuildContext context) {
  //   Color colorForText = getColor;
  //   if (color == TextColor.red) {
  //     colorForText = Theme.of(context).colorScheme.inversePrimary;
  //   } else {
  //     colorForText = Theme.of(context).colorScheme.surface;
  //   }
  //   return TextStyle(
  //       color: ,
  //       fontSize: fontSize,
  //       fontFamily: "Inter",
  //       fontWeight: FontWeight.bold,
  //       fontStyle: FontStyle.italic);
  // }
}
