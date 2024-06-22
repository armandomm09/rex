import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/components/generals/app_circular_progress.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/match_tile.dart';
import 'package:chat_app/components/visualization/line_chart.dart';
import 'package:chat_app/pages/publicSearch/match_details.dart';
import 'package:chat_app/services/TBA/tba_team.dart';
import 'package:chat_app/services/statbotics/statbotics_team.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TeamInEventDetails extends StatefulWidget {
  final String teamNickname;
  final String team;
  final String eventKey;
  const TeamInEventDetails(
      {super.key,
      required this.team,
      required this.eventKey,
      required this.teamNickname});

  @override
  State<TeamInEventDetails> createState() => _TeamInEventDetailsState();
}

class _TeamInEventDetailsState extends State<TeamInEventDetails>
    with TickerProviderStateMixin {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<dynamic> filteredMatches = [];

  List<dynamic> extendedMatches = [];

  var plotpoints = [];

  double opr = 0.0, dpr = 0.0, ccwm = 0.0;
  double winRate = 0.0;

  double avgMatch = 0.0, avgAuto = 0.0, avgStage = 0.0;

  late TabController tabController;
  bool isLoading = true;

  getPlotPoints() {
    print("getting plotpoits");
    List<FlSpot> spotsForTable = [];
    int matchCounter = 0;
    for (var i = 0; i < filteredMatches.length; i++) {
      var alliances = filteredMatches[i]["alliances"];
      var matchKey = filteredMatches[i]["key"];
      int score =
          (alliances["red"]["team_keys"].toString().contains(widget.team)
              ? alliances["red"]["score"]
              : alliances["blue"]["score"]);

      if (score != -1 && matchKey.toString().contains("qm")) {
        matchCounter += 1;
        //print("Match ${filteredMatches[i]["match_number"]}: $score");
        spotsForTable.add(FlSpot(matchCounter.toDouble(), score.toDouble()));
      }
    }
    return spotsForTable;
  }

  double recortarDecimales(double numero, int decimales) {
    var factor = pow(10, decimales);
    return (numero * factor).truncateToDouble() / factor;
  }

  initializeData() async {
    var list = await TBATeamService.getSimpleMatchesStream(
        widget.team, widget.eventKey);
    var extendedMatches2 = await TBATeamService.getMatchesByEventStream(
        widget.team, widget.eventKey);
    var OPRS = await TBATeamService.getOPRs(widget.team, widget.eventKey);
    var winRateGetter = await StatboticsTeamService.getTeamWinRateByYear(
        widget.team, StringUtil.removeLetters(widget.eventKey));
    var teamStatus =
        await TBATeamService.getStatusByEvent(widget.team, widget.eventKey);

    setState(() {
      filteredMatches = list;
      extendedMatches = extendedMatches2;
      try {
        opr = OPRS["opr"];
        dpr = OPRS["dpr"];
        ccwm = OPRS["ccwm"];
      } catch (e) {
        //print(e);
      }
      try {
        avgMatch = teamStatus["avgMatch"];
        avgAuto = teamStatus["avgAuto"];
        avgStage = teamStatus["avgStage"];
      } catch (e) {}
      winRate = winRateGetter;
    });
    setState(() {
      isLoading = false;
    });

    //print(extendedMatches[0]["score_breakdown"]["blue"]["teleopSpeakerNoteCount"]);
  }

  @override
  void initState() {
    try {
      initializeData();
      print("Data initialized");
    } catch (error) {
      print("Error fetching data: $error");
      // Potentially display an error message to the user
    }
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  getTeamData() {
    return AppLiquidPullRefresh(
      onRefresh: () => initializeData(),
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.tertiary),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  height: 70,
                  //width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "OPR",
                        textColor: TextColor.red,
                      ),
                      AppText(
                        text: recortarDecimales(opr, 4).toString(),
                        textColor: TextColor.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.tertiary),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  height: 70,
                  //width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "DPR",
                        textColor: TextColor.red,
                      ),
                      AppText(
                        text: recortarDecimales(dpr, 4).toString(),
                        textColor: TextColor.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.tertiary),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  height: 70,
                  //width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "CCWM",
                        textColor: TextColor.red,
                      ),
                      AppText(
                        text: recortarDecimales(ccwm, 4).toString(),
                        textColor: TextColor.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(8)),
                          //height: 50,
                          width: 120,
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: const AppText(
                                  text: "Avg Match",
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(8)),
                          //height: 50,
                          width: 120,
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: const AppText(
                                  text: "Avg Stage",
                                  textColor: TextColor.red,
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: AppText(
                                  text: avgStage.toString(),
                                  fontSize: 30,
                                  textColor: TextColor.red,
                                ))
                          ]),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(8)),
                          //height: 50,
                          width: 120,
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: const AppText(
                                  text: "Win Rate",
                                )),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: AppText(
                                  text: "${recortarDecimales(winRate * 100, 0)}%",
                                  fontSize: 30,
                                ))
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CarouselSlider(
                  items: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(8)),
                      //height: 50,
                      width: 150,
                      child: Column(children: [
                        Container(
                            margin: const EdgeInsets.all(15),
                            child: const AppText(
                              text: "Teleop note",
                            )),
                        Container(
                            child: AppText(
                              text: TBATeamService.getTeleopNoteCount(
                                      extendedMatches, widget.team)
                                  .toString(),
                              fontSize: 40,
                            ))
                      ]),
                    ),
                  ],
                  options: CarouselOptions(height: MediaQuery.of(context).size.height * 0.16),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 400,
                    //width: 350,
                    child: MyLineChart(
                      spots: getPlotPoints(),
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.transparent, //Theme.of(context).colorScheme.primary,
          elevation: 50,
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: AppText(
            text: widget.teamNickname,
            textColor: TextColor.red,
            fontSize: 28,
          ),
        ),
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
                        child:
                            isLoading ? const AppCircularProgress() : getTeamData())),
                Container(
                  child: Center(
                      child: ListView.separated(
                    itemBuilder: (context, index) {
                      String matchType = "";
                      String matchNumber = "";
                      if (filteredMatches[index]["key"]
                          .toString()
                          .contains("qm")) {
                        matchType = "Qualification";
                        matchNumber =
                            filteredMatches[index]["match_number"].toString();
                      } else if(filteredMatches[index]["key"]
                          .toString()
                          .contains("sf")){
                        matchType = "Semis";
                        var newMatchNumber = filteredMatches[index]["key"]
                            .toString()
                            .substring(11);
                        matchNumber = newMatchNumber.substring(
                            0, newMatchNumber.length - 2);
                      } else {
                        matchType = "Finals";
                        var newMatchNumber = filteredMatches[index]["key"]
                            .toString()
                            .substring(11);
                        matchNumber = newMatchNumber.substring(1);
                      }
                      return MatchTile(
                          matchNumber: matchNumber,
                          matchType: matchType,
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchDetails(
                                        matchKey: filteredMatches[index]["key"]
                                            .toString())),
                              ),
                          matchDate: DateTime.fromMillisecondsSinceEpoch(
                              filteredMatches[index]["time"] * 1000));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: filteredMatches.length,
                  )),
                ),
              ]),
            )
          ],
        ));
  }
}
