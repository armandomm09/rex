import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/user_tile.dart';
import 'package:chat_app/pages/chat/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/services/openai/scout_gpt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChats extends StatefulWidget {
  MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  setCurrentRegional() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("currentRegional", "Monterrey");
    }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentRegional();
   
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
              "/Users/Armando09/DART/chat_app/assets/images/background_color.png",
              height: 1000,
              fit: BoxFit.cover,
            ),
        ),
        Center(
          child: Image.asset(
              "/Users/Armando09/DART/chat_app/assets/images/app_background.png",
              height: 500,
              fit: BoxFit.cover,
            ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent, //Theme.of(context).colorScheme.primary,
            elevation: 50,
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: const AppText(text:"My chats", textColor: TextColor.red, fontSize: 28,),
          ),
          drawer: const AppDrawer(),
          body: buildUserStream(),
          
        ),
      ],
    );
  }

  Widget buildUserStream() {
    return StreamBuilder(
      stream: chatService.getUsersStream(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Text("There's been an error, try again later");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        List<Map<String, dynamic>> usersData = snapshot.data ?? [];

        return AppLiquidPullRefresh(
          onRefresh: () async {  },
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 10,);
            },
            itemCount: usersData.length,
            itemBuilder: (context, index) {
              return buildUserItem(usersData[index], context);
            },
          ),
        );
      },
    );
  }

  Widget buildUserItem(Map<String, dynamic> userData, BuildContext context) {
    if(userData["email"] != FirebaseAuth.instance.currentUser!.email){
      return UserTile(
      text: userData["email"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(recieverEmail: userData["email"], recieverID: userData["uid"],),
          ),
        );
      },
      
    );
    } else {
      return Container();
    }
  }
}
/*

*/ 