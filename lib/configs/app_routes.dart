import 'package:chat_app/pages/chat/my_chats.dart';
import 'package:chat_app/pages/scout/match_scout.dart';
import 'package:chat_app/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';


class AppRoutes{

  static const homePage ='/homePage';
  static const searchPage ='/searchPage';
  static const settingsPage ='/settingsPage';




  static  Map<String, WidgetBuilder> map = {
        homePage:(context) =>  const MyChats(),
        settingsPage:(context) => const SettingsPage(),
        searchPage:(context) => const NewMatchScouting(),
      };

}
