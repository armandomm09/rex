import 'package:chat_app/pages/chat/chat_with_database.dart';
import 'package:chat_app/pages/databaseSearch/favorite_teams.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/publicSearch/analyze_match.dart';
import 'package:chat_app/pages/chat/my_chats.dart';
import 'package:chat_app/pages/databaseSearch/robot_list.dart';
import 'package:chat_app/pages/databaseSearch/scouts_stream.dart';
import 'package:chat_app/pages/publicSearch/match_details.dart';
import 'package:chat_app/pages/publicSearch/team_season_details.dart';
import 'package:chat_app/pages/scout/my_scouts.dart';
import 'package:chat_app/pages/scout/search_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/settings/settings_page.dart';
import 'package:chat_app/services/auth/authgate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void signOut(BuildContext context){
    final auth = AuthService();
    auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthGate()));
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: DrawerHeader(
                  //margin: EdgeInsets.symmetric(vertical: 50),
                child: Column(children: [
                  Image.asset("assets/images/5887_trans.png", height: 125,),
                  //SizedBox(height: 20,)
                  ]),

                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("H O M E", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.home, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ),
              SizedBox(height: 12,),

             

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("M A T C H", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.note, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewMatchScouting()));
                  },
                    ),
              ),

              SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("F A V O R I T E S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.favorite, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoriteTeams()));
                  },
                    ),
              ),

              

             /* Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("M Y  S C O U T S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.remove_red_eye, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyScoutsPage()));
                  },
                    ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("D B  S C O U T S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.data_array, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScoutsStream()));
                  },
                    ),
              ),
              SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("R O B O T S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.phone_iphone, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  RobotListView()));
                  },
                    ),
              ),*/
              SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("M A T C H E S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchRegionals()));
                  },
                    ),
              ),

               SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("C H A T  W I T H  D B", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ChatWithDatabase()));
                  },
                    ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("C H A T", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.inversePrimary,)),
                  leading: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.inversePrimary,),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  MyChats()));
                  },
                    ),
              ),

               SizedBox(height: 12,),

           
              
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 0),
                  child: ListTile(
                    title: Text("S E T T I N G S", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.primary,)),
                    leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.inversePrimary,),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                    },
                  ),
                ),
                Padding(
                      padding: const EdgeInsets.only(left: 0, bottom: 0),
                      child: ListTile(
                        title: Text("L O G  O U T", style: TextStyle(fontFamily: "Industry", color: Theme.of(context).colorScheme.primary,)),
                        leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.inversePrimary,),
                        onTap: () {
                          signOut(context);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}