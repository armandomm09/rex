import 'dart:ui';

import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/generals/liquid_pull_to_Refresh.dart';
import 'package:chat_app/components/tiles/user_tile.dart';
import 'package:chat_app/pages/chat/chat_page.dart';
import 'package:chat_app/pages/chat/chat_with_database.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  
  loadBackgroundImage() async {
    try {
      await Hive.openBox("userData");
      var imagePathGet = await Hive.box("userData").get(1);
      print(imagePathGet);
    setState(() {
      backgroundImagePath = imagePathGet;
    });
    } catch (e) {
      print(e.toString());
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBackgroundImage();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  String backgroundImagePath = "assets/images/dominiSplash2.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, //Theme.of(context).colorScheme.primary,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const AppText(text:"My chats", textColor: TextColor.red, fontSize: 28,),
      ),
      drawer: const AppDrawer(),
      body:   AppLiquidPullRefresh(
        onRefresh: () async {},
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(backgroundImagePath))),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Color.fromARGB(213, 0, 0, 0),
              ),
            )),
              Column(
                children: [
                SizedBox(height: 120,),
                UserTile(text: 'Scout GPT', 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWithDatabase()));
                  },),
                
                Expanded(child: Center(
                  child: buildUserStream(),
                ))
              ]),
            ],
          ),
        ),
      )
  
       
      
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

        return ListView.separated(
          padding: EdgeInsets.all(0),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10,);
          },
          itemCount: usersData.length,
          itemBuilder: (context, index) {
            return buildUserItem(usersData[index], context);
          },
        );
      },
    );
  }

  Widget buildUserItem(Map<String, dynamic> userData, BuildContext context) {
    if(userData["email"] != FirebaseAuth.instance.currentUser!.email){
      return UserTile(
      text: StringUtil.toTitleCase(StringUtil.slitEmailString(userData["email"])),
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