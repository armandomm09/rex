import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {


  Future<String?> getCurrentRegional() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var string = prefs.getString("currentRegional");
      var currentRegional = string;
      return currentRegional;
    }

}