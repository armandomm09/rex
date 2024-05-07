import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class TeamTile extends StatelessWidget {
  final String teamNickname;
  final dynamic teamNumber;
  final void Function()? onTap;
  const TeamTile({super.key, required this.teamNickname, this.onTap, required this.teamNumber});

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
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(right: 50, left: 20),
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    children: [
                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppText(
                          text: teamNickname,
                          fontSize: 30,
                          textColor: TextColor.red
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              left: 50,
              child: Align(
                          alignment: Alignment.centerLeft,
                          child: AppText(
                            text: teamNumber.toString(),
                            fontSize: 23,
                            textColor: TextColor.red
                          ),
                        ),
            ),
          ],
        ),
      )
    );
  }
}