import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class EventTile extends StatelessWidget {
  final String eventName;
  final String eventLocation;
  final String eventType;
  final void Function()? onTap;
  final String webcast;
  const EventTile(
      {super.key,
      required this.eventName,
      this.onTap,
      required this.eventLocation,
      required this.eventType, required this.webcast});

  @override
  Widget build(BuildContext context) {

    String getEventLocationImage(){
    if(eventType == 'Championship Finals'){
      return 'assets/images/svgs/FIRSTicon_CMYK_withTM.svg';
    } else if(eventLocation.toLowerCase().contains("mexico")){
      return "assets/images/country_svg/mx.svg";
    } else if(eventLocation.toLowerCase().contains("canada")){
      return "assets/images/country_svg/canada_leaf.svg";
    } else if(eventLocation.toLowerCase().contains("Türkiye".toLowerCase())){
      return "assets/images/country_svg/tr-03.svg";
    } else if(eventLocation.toLowerCase().contains("USA".toLowerCase())){
      return "assets/images/country_svg/USA-Silhouette.svg";
    } else if(eventLocation.toLowerCase().contains("Israel".toLowerCase())){
      return "assets/images/country_svg/israel-silhouette.svg";
    }
    return "assets/images/country_svg/USA-Silhouette.svg";
  }


return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        enableTapToDismiss: false,
        richMessage: WidgetSpan(child: GestureDetector(
          child: SvgPicture.asset('assets/images/svgs/twitch-icon.svg', height: 40,), 
          onTap: () async {
            print('tocado');
            var url = 'https://www.twitch.tv/firstinspires_milstein';
            if(await canLaunchUrl(Uri.parse(webcast))){
              launchUrl(Uri.parse(webcast), mode: LaunchMode.externalApplication);
            }
            },)),
        child: Container(
          decoration: BoxDecoration(
            color: eventType == "Championship Division" || eventType == 'Championship Finals'
                ? Color.fromARGB(255, 229, 185, 11)
                : Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AppText(
                      text: eventLocation,
                      fontSize: 14,
                      textColor: eventType == "Championship Division" || eventType == 'Championship Finals'
                                 ? TextColor.black : TextColor.red,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          child: AppText(
                            text: eventName,
                            fontSize: 28,
                            textColor: eventType == "Championship Division" || eventType == 'Championship Finals' ? TextColor.black : TextColor.red,
                          
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
              Spacer(),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child: SvgPicture.asset(getEventLocationImage(), height: 50, color: Theme.of(context).colorScheme.inversePrimary,),
                            ),
                            
                          ],
                        )
            ],
          ),
        ),
      ),
    );
  }
}