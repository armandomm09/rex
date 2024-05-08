import 'dart:math';

import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/data_tile.dart';
import 'package:chat_app/services/TBA/tba_match.dart';
import 'package:chat_app/services/statbotics/statbotics_match.dart';
import 'package:chat_app/util/num_util.dart';
import 'package:flutter/material.dart';

class MatchDetails extends StatefulWidget {
  final String matchKey;
  const MatchDetails({
    super.key,
    required this.matchKey,
  });

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails>
    with TickerProviderStateMixin {
  String winner = '';
  double winningProb = 0.0;
  double redScore = 0.0;
  double blueScore = 0.0;
  double redNotesScored = 0.0;
  double blueNotesScored = 0.0;
  List<dynamic> extendedMatches = [];

  Alliance winning_alliance = Alliance.red;

  bool isLoading = true;

  String matchType = "";
  String matchNumber = "";

  late TabController tabController;

  double recortarDecimales(double numero, int decimales) {
    var factor = pow(10, decimales);
    return (numero * factor).truncateToDouble() / factor;
  }

  initializeData() async {
    print(widget.matchKey.substring(0, widget.matchKey.indexOf("_")));

    var TBApredicts = await TBAMatchService.getMatchPredict(widget.matchKey,
        widget.matchKey.substring(0, widget.matchKey.indexOf("_")));
    var SBPredicts = await StatboticsMatchService.getMatchPredict(widget.matchKey);
    print(TBApredicts['winner'] == SBPredicts['winner']);
    if(TBApredicts['winner'] == SBPredicts['winner']){
    setState(() {
      winning_alliance = TBApredicts['winner'] == 'red' ? Alliance.red : Alliance.blue;

      winningProb = NumUtil.recortarDecimales((TBApredicts['winningProb'] + SBPredicts['winningProb'])/2, 3);
      redScore = NumUtil.recortarDecimales((TBApredicts['redScore'] + SBPredicts['redScore'])/2, 1);
      blueScore = NumUtil.recortarDecimales((TBApredicts['blueScore'] + SBPredicts['blueScore'])/2, 1);
      redNotesScored =
          NumUtil.recortarDecimales(TBApredicts['redNotesScored'], 0);
      blueNotesScored =
          NumUtil.recortarDecimales(TBApredicts['blueNotesScored'], 0);
    });
    } else {
       setState(() {
      winning_alliance = TBApredicts['c'] == 'red' ? Alliance.red : Alliance.blue;

      winningProb = NumUtil.recortarDecimales(TBApredicts['winningProb'], 3);
      redScore = NumUtil.recortarDecimales(TBApredicts['redScore'], 1);
      blueScore = NumUtil.recortarDecimales(TBApredicts['blueScore'], 1);
      redNotesScored =
          NumUtil.recortarDecimales(TBApredicts['redNotesScored'], 1);
      blueNotesScored =
          NumUtil.recortarDecimales(TBApredicts['blueNotesScored'], 1);
    });
    }

    setState(() {

    if (widget.matchKey.toString().contains("qm")) {
      matchType = "Quals";
      matchNumber = widget.matchKey.toString().substring(11);
      //matchNumber = newMatchNumber.substring(0, newMatchNumber.length - 2);
    } else if(widget.matchKey.toString().contains("sf")) {
      matchType = "Semis";
      var newMatchNumber = widget.matchKey.toString().substring(11);
      matchNumber = newMatchNumber.substring(0, newMatchNumber.length - 2);
    } else{
      matchType = "Finals";
      var newMatchNumber = widget.matchKey.toString().substring(widget.matchKey.toString().length - 1);
      matchNumber = newMatchNumber;//.substring(0, newMatchNumber.length - 2);
    }
    print('${matchNumber}oo');
    });


  }

  @override
  void setState(fn) {
    if (mounted) {
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
            '$matchType $matchNumber',
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
                          child: getDetailsView(), onRefresh: () async {}))),
              Container(
                child: const Center(
                    child: Center(
                  child: AppText(
                    text: "2ND",
                    fontSize: 40,
                    textColor: TextColor.red,
                  ),
                )),
              ),
            ]),
          )
        ],
      ),
    );
  }

  getDetailsView() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const AppText(
          text: "Predicts",
          textColor: TextColor.red,
          fontSize: 40,
        ),
        DataTile(title: "Winnning prob", number: '${NumUtil.recortarDecimales(winningProb * 100, 1)}%', alliance: winning_alliance,),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: AppText(
          text: "Score:",
          textColor: TextColor.red,
          fontSize: 20,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataTile(
              title: "Red: ",
              number: redScore,
            ),
            DataTile(
              title: "Blue: ",
              number: blueScore,
              alliance: Alliance.blue,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: AppText(
          text: "Notes scored:",
          textColor: TextColor.red,
          fontSize: 20,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataTile(
              title: "Red: ",
              number: redNotesScored,
            ),
            DataTile(
              title: "Blue: ",
              number: blueNotesScored,
              alliance: Alliance.blue,
            )
          ],
        ),
      ],
    );
  }
}
