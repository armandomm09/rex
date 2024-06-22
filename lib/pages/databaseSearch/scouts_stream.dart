import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/imperator_tile.dart';
import 'package:chat_app/components/tiles/team_tile.dart';
import 'package:chat_app/pages/databaseSearch/scouted_team.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoutsStream extends StatefulWidget {
  const ScoutsStream({super.key});

  @override
  State<ScoutsStream> createState() => _ScoutsStreamState();
}

class _ScoutsStreamState extends State<ScoutsStream> {
  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  var scoutedTeams = [];
  List teamNames = [];
  List teamNumbers = []; // Empty list to store team names
  // Empty list to store team names
  String? currentRegional = "Monterrey";

  Future<String?> getCurrentRegional() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var string = prefs.getString("currentRegional");
      currentRegional = string;
      print(currentRegional);
      return currentRegional;
    }

  

  getClientStream() async {
  var data = FirebaseFirestore.instance
      .collection("scouts")
      .doc(currentRegional)
      .collection("matchScouts")
      .snapshots();

  data.listen((querySnapshot) {
    if (!mounted) return; // Verificar si el widget aún está montado
    scoutedTeams = querySnapshot.docs;
    var localNames = [];
    var localNumbers = [];

    for (var doc in scoutedTeams) {
      final teamName = doc.get("teamName");
      localNames.add(teamName.toString());
      localNumbers.add(doc.get("teamNumber").toString());
    }

    setState(() {
      teamNames = localNames;
      teamNumbers = localNumbers;
    });
  });
}


  goToTeamPage(String teamNickname, teamNumber){
    
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScoutedTeam(teamNickname: teamNickname, teamNumber: teamNumber,)
          ),
        );
  }

  getTeamsListView() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: AppLiquidPullRefresh(
        onRefresh: () => initStream(),
        child: ListView.separated(
          itemBuilder: (context, index) {
            var teamNickname = teamNames[index];
        
            var teamNumber = teamNumbers[index];
            if (teamNickname.toString().toLowerCase().contains("imperator")) {
              return ImperatorTile(
                teamNickname: teamNickname, teamNumber: teamNumber,
                onTap: () => goToTeamPage(teamNickname, teamNumber.toString()),
              );
            } else {
              return TeamTile(
                teamNickname: teamNickname,
                teamNumber: teamNumber.toString(),
                onTap: () => goToTeamPage(teamNickname, teamNumber.toString()),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 30,
            );
          },
          itemCount: teamNames.length,
        ),
      ),
    );
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

  initStream() async {
    await getCurrentRegional();
    await getClientStream();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStream();
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
          backgroundColor:
              Colors.transparent, //Theme.of(context).colorScheme.primary,
          elevation: 50,
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: const AppText(
            text: "Scouts stream",
            textColor: TextColor.red,
            fontSize: 28,
          ),
        ),
        body:
            teamNames.isNotEmpty ? getTeamsListView() : getNoTeamsContainer());
  }
}
