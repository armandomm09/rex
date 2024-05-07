import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegionalProvider {
  static Future init() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
  }
}
