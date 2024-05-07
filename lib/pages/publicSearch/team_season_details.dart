import 'dart:math';

import 'package:chat_app/components/generals/app_circular_progress.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/tiles/event_tile.dart';
import 'package:chat_app/components/tiles/teams_event_tile.dart';
import 'package:chat_app/services/TBA/tba_team.dart';
import 'package:chat_app/services/statbotics/statbotics_team.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TeamSeasonDetails extends StatefulWidget {
  final String teamNickname;
  final String team;
  final String year;
  const TeamSeasonDetails({super.key, required this.teamNickname, required this.team, required this.year});

  @override
  State<TeamSeasonDetails> createState() => _TeamSeasonDetailsState();
}

class _TeamSeasonDetailsState extends State<TeamSeasonDetails>
    with TickerProviderStateMixin {

  List<dynamic> extendedMatches = [];
  
  double avgMatch = 0.0, avgAuto = 0.0, avgStage = 0.0, winRate = 0.0, avgFouls = 0.0, avgTeleop = 0.0;
  
  bool isLoading = true;

  List events = [];


  late TabController tabController;

  double recortarDecimales(double numero, int decimales) {
    var factor = pow(10, decimales);
    return (numero * factor).truncateToDouble() / factor;
  }

  initializeData() async {
    print("initializing");
    var extendedMatches2 =
        await TBATeamService.getMatchesByYearStream(widget.team, widget.year);
    var winRateGetter = await StatboticsTeamService.getTeamWinRateByYear(
        widget.team, widget.year);
    var teamStatus =
        await TBATeamService.getStatusByYear(widget.team, widget.year);
    var tbaEvents = await TBATeamService.getEvents(widget.team, widget.year);
    setState(() {
      extendedMatches = extendedMatches2;
      events = tbaEvents;
      try {
        avgMatch = recortarDecimales(teamStatus["avgMatch"], 2) ;
        avgAuto = recortarDecimales(teamStatus["avgAuto"], 2);
        avgStage = recortarDecimales(teamStatus["avgStage"], 2);
      } catch (e) {}
      winRate = winRateGetter;
    });
    print(avgMatch);
    setState(() {
      isLoading = false;
    });
    var fouls = await TBATeamService.getFoulsAvg(extendedMatches, widget.team);
    var teleop = await TBATeamService.getTeleopAvg(extendedMatches, widget.team);
    if(mounted){
    setState(() {
      avgFouls = fouls;
      avgTeleop = teleop;
    });}
    print(avgTeleop);
   

    //print(extendedMatches[0]["score_breakdown"]["blue"]["teleopSpeakerNoteCount"]);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    initializeData();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 50,
          toolbarHeight: 70,
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            widget.teamNickname,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 28,
                fontFamily: "Industry",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          )),
      body: Column(
        children: [
          TabBar(controller: tabController, tabs: const [
            Tab(
              icon: Icon(Icons.data_array),
            ),
            Tab(
              icon: Icon(Icons.add),
            ),
          ]),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              Container(
                  child: Center(
                      child: AppLiquidPullRefresh(
                          child: isLoading ? AppCircularProgress() : getDetailsView(),
                          onRefresh: () async {}))),
              Container(
                child:  Center(child: isLoading ? AppCircularProgress() : getEventsStream(),),
              ),
            ]),
          )
        ],
      ),
    );
  }

  getEventsStream(){
    return AppLiquidPullRefresh(
            onRefresh: () =>getEventsStream(),
            child: Center(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var eventName;
                  if (events[index]['short_name'] != "") {
                    eventName = events[index]['short_name'];
                  } else {
                    eventName = events[index]['name'];
                  }
              
                  var eventLocation =
                      "${events[index]['city']}, ${events[index]['country']}";
              
                  var eventType = events[index]['event_type_string'];
              
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      TeamsEventTile(
                        eventName: eventName,
                        eventLocation: eventLocation,
                        eventType: eventType,
                                    
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: events.length,
              ),
            ),
          );
  }

  getDetailsView(){
    return Column(
                            children: [
                              const SizedBox(
                                height: 90,
                              ),

                      SizedBox(height: 20,),
                              
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Avg Match",
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: AppText(
                                        text: avgMatch.toString(),
                                        fontSize: 30,
                                      ))
                                ]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Avg Auto",
                                        textColor: TextColor.red,
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: AppText(
                                        text: avgAuto.toString(),
                                        fontSize: 30,
                                        textColor: TextColor.red,
                                      ))
                                ]),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Win Rate",
                                        textColor: TextColor.red,
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: CircularPercentIndicator(
                                center: AppText(text: "${(recortarDecimales(winRate, 1) * 100).toString()}%", textColor: TextColor.red, fontSize: 20,),
                                radius: 40,
                                lineWidth: 8,
                                percent: winRate,
                                //progressColor: Theme.of(context).colorScheme.inversePrimary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                animation: true,
                                rotateLinearGradient: true,
                                linearGradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    colors: [
                                      Color.fromARGB(255, 83, 14, 14),
                                      Color.fromARGB(255, 212, 35, 50),
                                      Color.fromARGB(255, 137, 23, 32),
                                    ]),
                              ),)
                                ]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Avg Stage",
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: AppText(
                                        text: avgStage.toString(),
                                        fontSize: 30,
                                        textColor: TextColor.black,
                                      ))
                                ]),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Avg Fouls",
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: AppText(
                                        text: avgFouls.toString(),
                                        fontSize: 30,
                                      ))
                                ]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary,
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                //height: 50,
                                width: 120,
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      child: const AppText(
                                        text: "Avg Teleop",
                                        textColor: TextColor.red,
                                      )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: AppText(
                                        text: avgTeleop.toString(),
                                        fontSize: 30,
                                        textColor: TextColor.red,
                                      ))
                                ]),
                              ),
                            ],
                          )
                            ],
                          );
  }
}
