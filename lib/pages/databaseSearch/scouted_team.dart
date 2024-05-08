
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/match_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScoutedTeam extends StatefulWidget {
  final String teamNickname;
  final String teamNumber;
  const ScoutedTeam(
      {super.key, required this.teamNumber, required this.teamNickname});

  @override
  State<ScoutedTeam> createState() => _ScoutedTeamState();
}

class _ScoutedTeamState extends State<ScoutedTeam> {
  List scoutedMatches = [];
  List matchesNumber = [];

  searchResultList() {
    var shownResults = [];

    shownResults = List.from(scoutedMatches);

    setState(() {
      print(shownResults.isEmpty);
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection("scouts")
        .doc("equipos")
        .collection("matchScouts")
        .doc(widget.teamNumber)
        .collection("matches")
        .get();

    setState(() {
      scoutedMatches = data.docs;
      scoutedMatches.sort(
          (a, b) => int.parse(a["match"]).compareTo(int.parse(b["match"])));
      // Ordena los documentos por el campo "match" convertido a entero
      for (int i = 0; i < scoutedMatches.length; i++) {
        print(scoutedMatches[i]["match"]);
      }
    });
    searchResultList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClientStream();
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
        body:Container(
          child: AppLiquidPullRefresh(
            onRefresh: () => getClientStream(),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return MatchTile(matchNumber: "Match ${scoutedMatches[index]["match"]}", matchType: scoutedMatches[index]["matchType"]);
              }, 
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10,);
              }, itemCount: scoutedMatches.length),
          ),
        )
        
      );
  }
}
