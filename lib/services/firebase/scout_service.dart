import 'package:chat_app/models/match_scout.dart';
import 'package:chat_app/models/match_scout_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PostState { successful, isDuplicated, serverError }

class ScoutService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> getCurrentRegional() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var string = prefs.getString("currentRegional");
      var currentRegional = string;
      return currentRegional;
    }


Future<List> getScoutsByUser(String? regional) async {
  List<String> teamNumbers = await getScoutedTeamsNumbers(regional);
  List filteredTeams = [];

  String? uid = FirebaseAuth.instance.currentUser!.uid;

  // Iterar sobre cada número de equipo
  for (String teamNumber in teamNumbers) {
    // Obtener los partidos para el equipo actual
    QuerySnapshot matchesSnapshot = await FirebaseFirestore.instance
        .collection("scouts")
        .doc(regional)
        .collection("matchScouts")
        .doc(teamNumber)
        .collection("matches")
        .where('senderId', isEqualTo: uid)
        .get();

    // Verificar si hay partidos donde el senderId sea igual a uid
    if (matchesSnapshot.docs.isNotEmpty) {
      // Si se encuentran partidos para el usuario actual, agregar el número de equipo a la lista filtrada
      filteredTeams.add(matchesSnapshot);
      
    }
  }
      
  //print(filteredTeams[0].docs.first.get("match"));
  return filteredTeams;
}

getMatchsByTeamAndUser(String regional, String team) async {
  //List<String> teamNumbers = await getScoutedTeamsNumbers(regional);
  List filteredMatches = [];

  String? uid = FirebaseAuth.instance.currentUser!.uid;

  // Iterar sobre cada número de equipo
    // Obtener los partidos para el equipo actual
    QuerySnapshot matchesSnapshot = await FirebaseFirestore.instance
        .collection("scouts")
        .doc(regional)
        .collection("matchScouts")
        .doc(team)
        .collection("matches")
        .where('senderId', isEqualTo: uid)
        .get();

    // Verificar si hay partidos donde el senderId sea igual a uid
    if (matchesSnapshot.docs.isNotEmpty) {
      // Si se encuentran partidos para el usuario actual, agregar el número de equipo a la lista filtrada
      filteredMatches.add(matchesSnapshot);
      
    }
      
  //print(filteredTeams[0].docs.first.get("match"));
  return filteredMatches;
}



  Future<List<String>> getScoutedTeamsNumbers(String? regional) async {
  List<String> localNumbers = [];

  FirebaseAuth.instance.currentUser!.uid;

  var data = FirebaseFirestore.instance
      .collection("scouts")
      .doc(regional)
      .collection("matchScouts")
      .get();

  var querySnapshot = await data;

  for (var doc in querySnapshot.docs) {
    final teamNumber = doc.get("teamNumber");
    localNumbers.add(teamNumber.toString());
    //print(teamNumber.toString());
  }

  //print(localNumbers);
  return localNumbers;
}


  Future<bool> isMatchScoutDuplicate(MatchScout matchScout, String? regional) async {
    // Create a query based on both teamNumber and match
    final query = await firestore
        .collection("scouts")
        .doc(regional)
        .collection("matchScouts")
        .doc(matchScout.teamNumber)
        .collection("matches")
        .where('teamNumber',
            isEqualTo: matchScout.teamNumber) // Replace with actual getter
        .where('match',
            isEqualTo: matchScout.match) // Replace with actual getter
        .get();

    // Check if any documents are found (duplicates)
    return query.docs.isNotEmpty;
  }

  Future<PostState> setTeamName(MatchScout matchScout, String? regional) async {
    try {
      final isDuplicate = await isMatchScoutDuplicate(matchScout, regional);

      if (!isDuplicate) {
        // If you need to update the team name separately, do it here
        await firestore
            .collection("scouts")
            .doc(regional)
            .collection("matchScouts")
            .doc(matchScout.teamNumber)
            .set({'teamName': matchScout.teamName});

        return PostState.successful;
      } else {
        return PostState.isDuplicated;
      }
    } catch (e) {
      return PostState.serverError;
    }
  }

  Future<PostState> sendMatchScout(MatchScout matchScout, String? regional) async {
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    try {
      final isDuplicate = await isMatchScoutDuplicate(matchScout, regional);

      if (!isDuplicate) {
        MatchScoutSender sender = MatchScoutSender(
          senderId: currentUserID,
          senderEmail: currentUserEmail,
          matchScout: matchScout,
          timestamp: timestamp,
        );

        // Add the sender data including the team name
        await firestore
            .collection("scouts")
            .doc(regional)
            .collection("matchScouts")
            .doc(matchScout.teamNumber)
            .collection("matches")
            .add(sender.toMap());

        // If you need to update the team name separately, do it here
        await firestore
            .collection("scouts")
            .doc(regional)
            .collection("matchScouts")
            .doc(matchScout.teamNumber)
            .set({
              'teamNumber': matchScout.teamNumber,
              'teamName': matchScout.teamName
              });

        return PostState.successful;
      } else {
        return PostState.isDuplicated;
      }
    } catch (e) {
      return PostState.serverError;
    }
  }
}
