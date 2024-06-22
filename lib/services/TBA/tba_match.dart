import 'dart:convert';

import 'package:http/http.dart' as httpp;

class TBAMatchService {

  static Future<Map<String, dynamic>> getMatchPredict(String matchKey, String eventKey) async {
  
  
  print("fetching..");
  var apiKey = "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  var url = "https://www.thebluealliance.com/api/v3/event/$eventKey/predictions";
  
  try {
    final response = await httpp.get(
      Uri.parse(url),
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode == 200) {
      var info = jsonDecode(response.body);
      var matchInfo;
      if(matchKey.contains("qm")){
       matchInfo = info["match_predictions"]["qual"][matchKey];
      } else {
        matchInfo = info["match_predictions"]["playoff"][matchKey];
      }

      return {
        "winner": matchInfo["winning_alliance"],
        "winningProb": matchInfo["prob"],
        "redScore": matchInfo["red"]["score"],
        "blueScore": matchInfo["blue"]["score"],
        "redNotesScored": matchInfo["red"]["note_scored"],
        "blueNotesScored": matchInfo["blue"]["note_scored"],
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