import 'dart:convert';

import 'package:http/http.dart' as httpp;


class StatboticsMatchService {

  static Future<Map<String, dynamic>> getMatchPredict(String matchKey) async {
  
  
  print("fetching..");
  var url = "https://api.statbotics.io/v3/match/$matchKey";
  
  try {
    final response = await httpp.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var info = jsonDecode(response.body);
      var matchInfo = info["pred"];
      var winningProb = matchInfo["red_win_prob"];
      if(matchInfo["winning_alliance"] == 'blue'){winningProb = 1 - winningProb;}
      return {
        "winner": matchInfo["winner"],
        "winningProb": winningProb,
        "redScore": matchInfo["red_score"],
        "blueScore": matchInfo["blue_score"],
      };
       
      } else {
        return {};
      }
      
      // Iterar sobre todas las claves en el objeto info
  } catch (e) {
    print("Error fetching events: ooo $e");
    return {};
  }
  }


}