import 'dart:convert';

import 'package:http/http.dart' as httpp;

class StatboticsTeamService {


  static Future<double> getTeamWinRateByYear(String teamNumber, String year) async {
    double winRate = 0.0;
    var url =
        "https://api.statbotics.io/v2/team_year/$teamNumber/$year";
    try {
      final response = await httpp.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        
        winRate = responseBody["winrate"];
        
      } else {
        print("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");

    }
    return winRate;
  }
}