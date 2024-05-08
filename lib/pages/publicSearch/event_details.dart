import 'dart:convert';

import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/tiles/imperator_tile.dart';
import 'package:chat_app/components/tiles/team_tile.dart';
import 'package:chat_app/pages/publicSearch/team_inevent_details.dart';
import 'package:chat_app/services/firebase/user_data.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as httpp;

class EventDetails extends StatefulWidget {
  final String eventCode;
  final String eventName;
  const EventDetails(
      {super.key, required this.eventCode, required this.eventName});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> allTeams = [];
  List<dynamic> filteredTeams = [];

  

  getTeamsStream() async {
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url = "https://www.thebluealliance.com/api/v3/event/${widget.eventCode}/teams";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        setState(() {
          allTeams = jsonDecode(response.body);
          filteredTeams = allTeams;
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
    if (searchController.text != "") {
      for (var team in allTeams) {
        var name = team['nickname'].toString().toLowerCase();
        var teamNumber = team['team_number'].toString().toLowerCase();

        if (name.contains(searchController.text.toLowerCase()) ||
            teamNumber.contains(searchController.text.toLowerCase())) {
          shownResults.add(team);
        }
      }
    } else {
      shownResults = List.from(allTeams);
    }

    setState(() {
      filteredTeams = shownResults;
    });
  }

  getNoTeamsContainer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            child: const AppText(
              text: "Sorry, the teams are not posted yet",
              textColor: TextColor.red,
              fontSize: 40,
            ),
          ),
          SvgPicture.asset(
            "/Users/Armando09/DART/chat_app/assets/images/svgs/sad-emoji-svgrepo-com.svg",
            color: Theme.of(context).colorScheme.inversePrimary,
          )
        ],
      ),
    );
  }

  goToTeamPage(String teamNickname, team, eventCode){
    
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamInEventDetails(teamNickname: teamNickname, eventKey: eventCode, team: team,)
          ),
        );
  }

  getTeamsListView() {
    return AppLiquidPullRefresh(
      onRefresh: () => getTeamsStream(),
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            var teamNickname = filteredTeams[index]['nickname'];
      
            var teamNumber = filteredTeams[index]['team_number'];
            if (teamNickname.toString().toLowerCase().contains("imperator")) {
              return Slidable(
                startActionPane: ActionPane(
                motion: const ScrollMotion(), 
                children: [
                 
                    SlidableAction(
                    onPressed: (value) {
                      UserData().setFavoriteTeam(teamNumber.toString(), teamNickname.toString());
                    },
                    icon: Icons.favorite,
                    backgroundColor: const Color.fromARGB(255, 244, 209, 54),
                    foregroundColor: Colors.black,
                    spacing: 10,
                    ),
                ]),
                child: ImperatorTile(
                    teamNickname: teamNickname, teamNumber: teamNumber,
                    onTap: () => goToTeamPage(teamNickname, teamNumber.toString(), widget.eventCode),
                    
                    ),
              );
            } else {
              return Slidable(
                startActionPane: ActionPane(
                motion: const ScrollMotion(), 
                children: [
                 
                    SlidableAction(
                    onPressed: (value) {
                      UserData().setFavoriteTeam(teamNumber.toString(), teamNickname.toString());
                    },
                    icon: Icons.favorite,
                    backgroundColor: const Color.fromARGB(255, 244, 209, 54),
                    foregroundColor: Colors.black,
                    spacing: 10,
                    ),
                ]),
                child: TeamTile(
                  teamNickname: teamNickname,
                  teamNumber: teamNumber,
                  onTap: () => goToTeamPage(teamNickname, teamNumber.toString(), widget.eventCode),
                ),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 30,
            );
          },
          itemCount: filteredTeams.length,
        ),
      ),
    );
  }

  @override
  void initState() {
    searchController.addListener(searchResultList);
    // TODO: implement initState
    super.initState();
    getTeamsStream();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
void dispose() {
  searchController.removeListener(searchResultList);
  searchController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 50,
            toolbarHeight: 100,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 225,
                      child: AppText(
                        text: widget.eventName,
                        textColor: TextColor.red,
                        fontSize: 28,
                      ),
                    ),
                    AppText(
                      text: StringUtil.removeLetters(widget.eventCode),
                      textColor: TextColor.red,
                      fontSize: 28,
                    ),
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
        body: allTeams.isNotEmpty ? getTeamsListView() : getNoTeamsContainer());
  }
}
