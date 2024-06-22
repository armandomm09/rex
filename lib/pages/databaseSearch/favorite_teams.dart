import 'package:chat_app/components/generals/app_circular_progress.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/tiles/team_tile.dart';
import 'package:chat_app/pages/publicSearch/team_season_details.dart';
import 'package:chat_app/services/firebase/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoriteTeams extends StatefulWidget {
  const FavoriteTeams({super.key});

  @override
  State<FavoriteTeams> createState() => _FavoriteTeamsState();
}

class _FavoriteTeamsState extends State<FavoriteTeams> {
  var favorite_teams;

  initializeData() async {
    var favTeams = await UserData().getFavoriteTeams();
    setState(() {
      favorite_teams = favTeams;
    });
    //print(favorite_teams);
  }

  getTeamsListView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          var teamNumber = favorite_teams[0]["numbers"][index];
          var teamName = favorite_teams[0]["names"][index];
          var teamID = favorite_teams[0]["ids"][index];
          return Slidable(
            startActionPane:
                ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                icon: Icons.delete,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: Colors.black,
                onPressed: (BuildContext context) {
                  UserData().deleteFavoriteTeam(teamID);
                  initializeData();
                },
              )
            ]),
            child: TeamTile(
              teamNickname: teamName,
              teamNumber: teamNumber,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamSeasonDetails(
                          teamNickname: teamName,
                          team: teamNumber,
                          year: "2024")),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: favorite_teams[0]["numbers"].length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> users = [];
    postList() {
      for (var i = 0; i < 30; i++) {
        users.add("User number $i");
      }
    }

    postList();

    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
            elevation: 50,
            toolbarHeight: 70,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              "Favorites",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 28,
                  fontFamily: "Industry",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            )),
        body: AppLiquidPullRefresh(
          onRefresh: () async {
            initializeData();
          },
          child: favorite_teams == null || favorite_teams.isEmpty
              ? const AppCircularProgress()
              : getTeamsListView(),
        ));
  }
}

/*

            */