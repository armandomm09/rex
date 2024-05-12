import 'package:chat_app/components/generals/app_circular_progress.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/tiles/team_tile.dart';
import 'package:chat_app/pages/scout/my_scouted_team.dart';
import 'package:chat_app/pages/scout/match_scout.dart';
import 'package:chat_app/services/firebase/scout_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyScoutsPage extends StatefulWidget {
  const MyScoutsPage({super.key});

  @override
  State<MyScoutsPage> createState() => _MyScoutsPageState();
}

class _MyScoutsPageState extends State<MyScoutsPage> {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  List docsList = [];
  List teamNames = [];
  List teamNumbers = [];

  Future<String?> getCurrentRegional() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getString("currentRegional");
    var currentRegional = string;
    return currentRegional;
  }

  getTeams() async {
    docsList = await ScoutService().getScoutsByUser(await getCurrentRegional());
  }

  getNamesAndNumbers() {
    for (int i = 0; i < docsList.length; i++) {
      for (int j = 0; j < docsList[i].docs.length; j++) {
        var name = docsList[i].docs[j].get("teamName");
        var number = docsList[i].docs[j].get("teamNumber");
        teamNames.add(name);
        teamNumbers.add(number);
        //print(number + ": " +name);
      }
    }
    if(mounted){
    setState(() {
      teamNames = teamNames.toSet().toList();
      teamNumbers = teamNumbers.toSet().toList();
    });
    }
  }

  initStream() async {
    await getTeams();
    await getNamesAndNumbers();
    //print(teamNames);
    //print(teamNumbers);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStream();
  }

  goToTeamPage(String teamNickname, teamNumber){
    
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyScoutedTeam(teamNickname: teamNickname, teamNumber: teamNumber,)
          ),
        );
  }

  getBuild() {
    initStream();

    return AppLiquidPullRefresh(
      onRefresh: () => initStream(),
      child: ListView.separated(
        itemBuilder: (context, index) {
          // Verificar si el índice está dentro del rango válido de teamNames y teamNumbers
          if (index < teamNames.length && index < teamNumbers.length) {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(), 
                children: [
                 SlidableAction(
                    onPressed: (value) {},
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.black,
                    spacing: 10,
                    ),
                    SlidableAction(
                    onPressed: (value) {},
                    icon: Icons.edit,
                    backgroundColor: const Color.fromARGB(255, 244, 209, 54),
                    foregroundColor: Colors.black,
                    spacing: 10,
                    ),
                ]),
                endActionPane: ActionPane(
                motion: const ScrollMotion(), 
                children: [
                    SlidableAction(
                    onPressed: (value) {},
                    icon: Icons.upload,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    spacing: 10,
                    ),
                ]),
              child: TeamTile(
                onTap: (){
                  
                },
                teamNickname: teamNames[index],
                teamNumber: teamNumbers[index],
              ),
            );
          } else {
            return Container(); // Manejar caso de índice fuera de rango
          }
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 20);
        },
        itemCount: teamNames.length < teamNumbers.length
            ? teamNames.length
            : teamNumbers.length, // Usar el tamaño más pequeño de ambas listas
      ),
    );
  }

  getCircularProgress() {
    return Center(
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(left: 0, bottom: 20),
          child: Image.asset(
            "assets/images/5887_trans.png", 
            height:50,
            //width: 30,
            //fit: BoxFit.cover,
            ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8),
          child: CircularProgressIndicator(strokeWidth: 5, strokeAlign: 9, color: Theme.of(context).colorScheme.inversePrimary,))
      ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.surface, size: 40,),
          onPressed: () {
            Navigator.push(context,  
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const NewMatchScouting(),
              transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(opacity: animation, child: child);
              }),
            );
          } ),
        appBar: AppBar(
            elevation: 50,
            toolbarHeight: 70,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              "My scouts",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 28,
                  fontFamily: "Industry",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            )),
        drawer: const AppDrawer(),
        body: teamNames.isNotEmpty ? getBuild() : const AppCircularProgress()
        );
  }
}
