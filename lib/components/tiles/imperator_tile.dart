import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class ImperatorTile extends StatelessWidget {
  final String teamNickname;
  final dynamic teamNumber;
  final void Function()? onTap;
  const ImperatorTile({super.key, required this.teamNickname, this.onTap, required this.teamNumber});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(right: 50, left: 20),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Image.asset("assets/images/5887_2024_hB.png"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}


/*
Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              text: "IMPERATOR",
                              fontSize: 30,
                              textColor: TextColor.black 
                            ),
                          ),
                          Spacer(),
                      Image.asset("/Users/Armando09/DART/chat_app/assets/images/5887_2024D.png", height: 50,)

                        ],
                      )
                      */