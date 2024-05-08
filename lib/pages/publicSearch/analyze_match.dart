import 'dart:convert';

import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/tiles/event_tile.dart';
import 'package:chat_app/pages/publicSearch/event_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpp;

class SearchRegionals extends StatefulWidget {
  const SearchRegionals({super.key});

  @override
  State<SearchRegionals> createState() => _SearchRegionalsState();
}

class _SearchRegionalsState extends State<SearchRegionals> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> allEvents = [];
  List<dynamic> filteredEvents = [];
  List<PopupMenuItem> allYears = [];

  String currentYear = "2024";

  getEventsStream(String year) async {
  var apiKey =
      "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  var url = "https://www.thebluealliance.com/api/v3/events/$year";

  try {
    final response = await httpp.get(
      Uri.parse(url),
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final allEvents = jsonDecode(response.body) as List<dynamic>;

      // Prioritize Championship events (combine conditions for efficiency)
      final prioritizedEvents = allEvents.where((event) =>
          event['event_type_string'] == "Championship Division" ||
          event['event_type_string'] == "Championship Finals").toList();

      // Add remaining events
      prioritizedEvents.addAll(allEvents.where((event) =>
          event['event_type_string'] != "Championship Division" &&
          event['event_type_string'] != "Championship Finals").toList());

      setState(() {
        filteredEvents = prioritizedEvents;
      });
   
    } else {
      print("Failed to load events: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching events: $e");
  }
}


  searchResultList() {
    var shownResults = [];
    if(searchController.text != ""){
      for(var event in allEvents){
        var name = event['name'].toString().toLowerCase();
        var city = event['city'].toString().toLowerCase();
        var country = event['country'].toString().toLowerCase();
        
        if(name.contains(searchController.text.toLowerCase()) || city.contains(searchController.text.toLowerCase()) || country.contains(searchController.text.toLowerCase())){
          shownResults.add(event);
        }
      }
    } else {
      shownResults = List.from(allEvents);
    }

    setState(() {
      filteredEvents = shownResults;
    });
  }

  goToEventPage(String eventCode, eventName){
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(eventCode: eventCode, eventName: eventName,)
          ),
        );
  }

  @override
  void initState() {
    for(var i = 2024; i >= 1994; i--){
      allYears.add(PopupMenuItem(value: i,child: AppText(text: i.toString(), textColor: TextColor.red,),));
    }
    searchController.addListener(searchResultList);
    // TODO: implement initState
    super.initState();
    getEventsStream("2024");
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
            elevation: 50,
            toolbarHeight: 100,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const AppText(
                        text: "Regionals",
                        textColor: TextColor.red,
                        fontSize: 28,
                      ),
                    PopupMenuButton(
                      child: AppText(text: currentYear, textColor: TextColor.red, fontSize: 25,),
                      //icon: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary,),
                      onSelected: (value) {
                        setState(() {
                          currentYear = value.toString();
                          getEventsStream(value.toString());
                        });
                      },
                      itemBuilder: (context) {
                      return allYears;
                    })
                  ],
                ),
                CupertinoSearchTextField(
                  // decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
                  itemColor: Theme.of(context).colorScheme.surface,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontFamily: "Industry",
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  controller: searchController,
                ),
              ],
            )),
        body: Container(
          margin: const EdgeInsets.only(top: 20),
          child: AppLiquidPullRefresh(
            onRefresh: () =>getEventsStream("2024"),
            child: ListView.separated(
              itemBuilder: (context, index) {
                var eventName;
                var webcast = '';
                if (filteredEvents[index]['short_name'] != "") {
                  eventName = filteredEvents[index]['short_name'];
                } else {
                  eventName = filteredEvents[index]['name'];
                }
                try {
                  if(filteredEvents[index]['webcasts'] != null ){
                  if(filteredEvents[index]['webcasts'][0]['type'].toString() == 'twitch'){
                webcast = 'https://www.twitch.tv/'+ filteredEvents[index]['webcasts'][0]['channel'];}
                }
                } catch (e) {
                  webcast = '';
                  print(e);
                }
                
                var eventLocation =
                    "${filteredEvents[index]['city']}, ${filteredEvents[index]['country']}";
            
                var eventType = filteredEvents[index]['event_type_string'];
            
                return EventTile(
                  webcast: webcast,
                  onTap: () {
                    print(filteredEvents[index]['key']);
                    print(eventType);
                    goToEventPage(filteredEvents[index]['key'], eventName);
                  },
                  eventName: eventName,
                  eventLocation: eventLocation,
                  eventType: eventType,
            
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 30,
                );
              },
              itemCount: filteredEvents.length,
            ),
          ),
        ));
  }
}

/*
ListView.separated(
        itemBuilder: (context, index) {
          var eventName;
          if(filteredEvents[index]['short_name'] != ""){
            eventName = filteredEvents[index]['short_name'];
          } else {
            eventName = filteredEvents[index]['name'];
          }
          
          var eventLocation = "${filteredEvents[index]['city']}, ${filteredEvents[index]['country']}";
          return EventTile(eventName: eventName, eventLocation: eventLocation);
        },
        separatorBuilder: (context, index) {
         return SizedBox(height: 20,);
        },
        itemCount: filteredEvents.length,)



CupertinoSearchTextField(
         // decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
          itemColor: Theme.of(context).colorScheme.background,
          style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 18,
                    fontFamily: "Industry",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
          controller: searchController,
        ),
        */