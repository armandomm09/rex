import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchTile extends StatelessWidget {
  final String matchNumber;
  final String matchType;
  final void Function()? onTap;
  final DateTime? matchDate;
  const MatchTile({super.key, required this.matchNumber, required this.matchType, this.onTap, this.matchDate});

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
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              text: matchNumber,
                              fontSize: 30,
                              textColor: TextColor.red
                            ),
                          ), 
                          AppText(text: matchDate == null ? "" : DateFormat('dd/MM HH:mm').format(matchDate!).toString(), textColor: TextColor.red,)
                        ],
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
                            text: matchType,
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