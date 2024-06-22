import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as httpp;

class TBATeamService {
  static var apiKey = "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  
  static recortarDecimales(double numero, int decimales) {  
    var factor = pow(10, decimales);
    return (numero * factor).truncateToDouble() / factor;
  }

  static Future<dynamic> getStatusByEvent(String teamNumber, String eventCode) async {
    var avgMatch;
    var avgAuto;
    var avgStage;
    print("fetching..");
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url =
        "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventCode/status";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        var info = jsonDecode(response.body);
        avgMatch = info['qual']['ranking']['sort_orders'][2];
        avgAuto = info['qual']['ranking']['sort_orders'][3];
        avgStage = info['qual']['ranking']['sort_orders'][4];
        
        
      return {
        "avgMatch": avgMatch,
        "avgAuto": avgAuto,
        "avgStage": avgStage
      };
      } else {
        print("Failed to load events: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching events: $e");
      return {};

    }
  }

  static Future<List> getEvents(String teamNumber, String year) async {
  var events =[];
  
  print("fetching..");
  print(teamNumber);
  print(year);
  var apiKey = "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  var url = "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/events/$year";
  
  try {
    final response = await httpp.get(
      Uri.parse(url),
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode == 200) {
      var info = jsonDecode(response.body);
      events = info;
      print(events[0]['name']);
     return events;
    } else {
      print("Failed to load events: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error fetching events: ooo $e");
    return [];
  }
}

  static Future<Map<String, dynamic>> getStatusByYear(String teamNumber, String year) async {
  var avgMatchTotal = 0.0;
  var avgAutoTotal = 0.0;
  var avgStageTotal = 0.0;
  var numTeams = 0;
  
  print("fetching..");
  print(teamNumber);
  print(year);
  var apiKey = "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
  var url = "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/events/$year/statuses";
  
  try {
    final response = await httpp.get(
      Uri.parse(url),
      headers: {'X-TBA-Auth-Key': apiKey},
    );

    if (response.statusCode == 200) {
      var info = jsonDecode(response.body);

      // Iterar sobre todas las claves en el objeto info
      info.forEach((key, value) {
          var sortOrders = value['qual']['ranking']['sort_orders'];
            var avgMatch = sortOrders[2];
            var avgAuto = sortOrders[3];
            var avgStage = sortOrders[4];
            
            avgMatchTotal += avgMatch;
            avgAutoTotal += avgAuto;
            avgStageTotal += avgStage;
            numTeams++;
            
            
         // }
       // }
      });

      var avgMatch = numTeams > 0 ? avgMatchTotal / numTeams : 0;
      var avgAuto = numTeams > 0 ? avgAutoTotal / numTeams : 0;
      var avgStage = numTeams > 0 ? avgStageTotal / numTeams : 0;

      return {
        "avgMatch": avgMatch,
        "avgAuto": avgAuto,
        "avgStage": avgStage
      };
    } else {
      print("Failed to load events: ${response.statusCode}");
      return {};
    }
  } catch (e) {
    print("Error fetching events: ooo $e");
    return {};
  }
}



  

  static Future<dynamic> getOPRs(String teamNumber, String eventCode) async {
    var opr;
    var dpr;
    var ccwm;
    print("fetching..");
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url =
        "https://www.thebluealliance.com/api/v3/event/$eventCode/oprs";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        var oprs = jsonDecode(response.body);
        opr = oprs["oprs"]["frc$teamNumber"];
        dpr = oprs["dprs"]["frc$teamNumber"];
        ccwm = oprs["ccwms"]["frc$teamNumber"];
        
        
      return {
        "opr": opr,
        "dpr": dpr,
        "ccwm": ccwm
      };
      } else {
        print("Failed to load events: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching events: $e");
      return {};

    }
  }

  static getTeleopAvg(List extendedMatches, String team) {
      double matchCounter = 1;
    print("getting plotpoits");
    double generalNoteCount = 0;
  try{
    for (var i = 0; i < extendedMatches.length; i++) {
      var alliances = extendedMatches[i]["alliances"];
      if(extendedMatches[i]["score_breakdown"] != null){
      var isRedAlliance = alliances["red"]["team_keys"].toString().contains(team);
      var noteCount =
          (isRedAlliance
              ? extendedMatches[i]["score_breakdown"]["red"]["teleopPoints"]
              : extendedMatches[i]["score_breakdown"]["blue"]["teleopPoints"]);

        generalNoteCount += noteCount;
        matchCounter += 1;
     
      }
    }
    return recortarDecimales(generalNoteCount / matchCounter  , 3);}
    catch(e){
      print("mala lista");
    }
  }


  static getFoulsAvg(List extendedMatches, String team) {
      double matchCounter = 1;
    print("getting plotpoits");
    double generalNoteCount = 0;
  try{
    for (var i = 0; i < extendedMatches.length; i++) {
      var alliances = extendedMatches[i]["alliances"];
      if(extendedMatches[i]["score_breakdown"] != null){
      var isRedAlliance = alliances["red"]["team_keys"].toString().contains(team);
      var noteCount =
          (isRedAlliance
              ? extendedMatches[i]["score_breakdown"]["blue"]["foulPoints"]
              : extendedMatches[i]["score_breakdown"]["red"]["foulPoints"]);
      

      //if (matchKey.toString().contains("qm")) {
        generalNoteCount += noteCount;
        matchCounter += 1;
      /*print(matchNumber.toString() + " Is red alliance?: " + 
      alliances["red"]["team_keys"].toString().contains(team).toString() + 
      ", notes: " + noteCount.toString());*/
      }
    }
   // print(totalPointsCounter / matchCounter );
    return recortarDecimales(generalNoteCount / matchCounter /3 , 3);}
    catch(e){
      print("mala lista");
    }
  }
  
    static getTeleopNoteCount(List extendedMatches, String team) {
      double matchCounter = 1;
    print("getting plotpoits");
    double generalNoteCount = 0;
    double totalPointsCounter = 0;
  try{
    for (var i = 0; i < extendedMatches.length; i++) {
      var alliances = extendedMatches[i]["alliances"];
      if(extendedMatches[i]["score_breakdown"] != null){
      var isRedAlliance = alliances["red"]["team_keys"].toString().contains(team);
      var noteCount =
          (isRedAlliance
              ? extendedMatches[i]["score_breakdown"]["red"]["teleopSpeakerNoteCount"]
              : extendedMatches[i]["score_breakdown"]["blue"]["teleopSpeakerNoteCount"]);
      var totalPoints = isRedAlliance 
              ? extendedMatches[i]["score_breakdown"]["red"]["totalPoints"]
              : extendedMatches[i]["score_breakdown"]["blue"]["totalPoints"];

      //if (matchKey.toString().contains("qm")) {
        generalNoteCount += noteCount;
        totalPointsCounter += totalPoints;
        matchCounter += 1;
      /*print(matchNumber.toString() + " Is red alliance?: " + 
      alliances["red"]["team_keys"].toString().contains(team).toString() + 
      ", notes: " + noteCount.toString());*/
      }
    }
    print(totalPointsCounter / matchCounter );
    return recortarDecimales(generalNoteCount / matchCounter /3 , 3);}
    catch(e){
      print("mala lista");
    }
  }

   static Future<List> getMatchesByEventStream(String teamNumber, String eventCode) async {

    List matches = [];
    print("fetching..");
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url =
        "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventCode/matches";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        matches = jsonDecode(response.body);
        matches.sort((a, b) => a["match_number"].compareTo(b["match_number"]));
        return matches;

      //print(matches[0]["score_breakdown"]["blue"]["teleopSpeakerNoteCount"]);
      
      } else {
        print("Failed to load events: ${response.statusCode}");
        return []; // Return empty list on error
      }
    } catch (e) {
      print("Error fetching events: $e");
        return []; // Return empty list on error

    }
  }

  static Future<List> getMatchesByYearStream(String teamNumber, String year) async {

    List matches = [];
    print("fetching..");
    var apiKey =
        "WFoNaSbMFws9MIaRrXrSTbglBWpv60ZUZi96Pmg4XFzPY828s5DT5NATHORA2OUs";
    var url =
        "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/matches/$year";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        matches = jsonDecode(response.body);
        matches.sort((a, b) => a["match_number"].compareTo(b["match_number"]));
        return matches;

      //print(matches[0]["score_breakdown"]["blue"]["teleopSpeakerNoteCount"]);
      
      } else {
        print("Failed to load events: ${response.statusCode}");
        return []; // Return empty list on error
      }
    } catch (e) {
      print("Error fetching events: $e");
        return []; // Return empty list on error

    }
  }

  static Future<List<dynamic>> getSimpleMatchesStream(String teamNumber, String eventCode) async {
    print("fetching..");
    var url =
        "https://www.thebluealliance.com/api/v3/team/frc$teamNumber/event/$eventCode/matches/simple";
    try {
      final response = await httpp.get(
        Uri.parse(url),
        headers: {'X-TBA-Auth-Key': apiKey},
      );

      if (response.statusCode == 200) {
        List<dynamic> matches = jsonDecode(response.body);
        matches.sort((a, b) => a["match_number"].compareTo(b["match_number"]));
        return matches;
      } else {
        print("Failed to load events: ${response.statusCode}");
        return []; // Return empty list on error
      }
    } catch (e) {
      print("Error fetching events: $e");
      return []; // Return empty list on error
    }
  }

  
}