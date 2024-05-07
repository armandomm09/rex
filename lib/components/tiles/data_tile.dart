import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/util/num_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Alliance {
  blue, red
}
class DataTile extends StatelessWidget {
   final String title;
   final dynamic number;
   final double? width;
   final Alliance alliance;
  const DataTile({super.key, required this.title, required this.number, this.width, this.alliance = Alliance.red});

  getAllianceColor(){
    if(alliance == Alliance.red){
      return TextColor.redAlliance;
    } else if(alliance == Alliance.blue){
      return TextColor.blueAlliance;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primary),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(15),
                        height: 70,
                        width: width,
                        child:  Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                             AppText(
                              text: title,
                              textColor: getAllianceColor(),
                            ),
                            AppText(
                              text:
                                 number.runtimeType == double ? NumUtil.recortarDecimales(number, 4).toString() : number,
                              textColor: getAllianceColor(),
                            ),
                          ],
                        ),
                      );
  }
}