import 'package:chat_app/pages/databaseSearch/favorite_teams.dart';
import 'package:chat_app/pages/publicSearch/analyze_match.dart';
import 'package:chat_app/pages/publicSearch/team_inevent_details.dart';
import 'package:chat_app/pages/publicSearch/team_season_details.dart';
import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  setCurrentRegional(String regional) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("currentRegional", regional);
    }


  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {

          if(snapshot.hasData){
            setCurrentRegional("Monterrey");
            return FavoriteTeams();//TeamDetails( teamNickname: "Imperator", team: "5887", eventKey: "2024mxpu");
          } else {
            return const LoginOrRegisterPage();
          }      
        }),
    );
  }
}