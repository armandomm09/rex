import 'package:chat_app/models/gpt_message.dart';
import 'package:chat_app/models/match_scout.dart';
import 'package:chat_app/services/firebase/scout_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final String currentUserID = auth.currentUser!.uid;

  Future<bool> alreadyIsAFavoriteTeam(String teamNumber) async {
    // Create a query based on both teamNumber and match
    final query = await firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("favoriteTeams")
        .where('teamNumber',
            isEqualTo: teamNumber) // Replace with actual getter
        .get();

    // Check if any documents are found (duplicates)
    return query.docs.isEmpty;
  }

  Future<PostState> setFavoriteTeam(String teamNumber, String teamName) async {
    try {
      final notDuplicated = await alreadyIsAFavoriteTeam(teamNumber);
      if (notDuplicated) {
        await firestore
            .collection("Users")
            .doc(currentUserID)
            .collection("favoriteTeams")
            .add({"teamNumber": teamNumber, "teamName": teamName});
        return PostState.successful;
      } else {
        return PostState.isDuplicated;
      }
    } catch (e) {
      return PostState.serverError;
    }
  }

  Future<PostState> deleteFavoriteTeam(String docID) async {
    try {
      //final isDuplicate = await alreadyIsAFavoriteTeam(teamNumber);
        await firestore
            .collection("Users")
            .doc(currentUserID)
            .collection("favoriteTeams")
            .doc(docID)
            .delete();
            //.add({"teamNumber": teamNumber, "teamName": teamName});
        return PostState.successful;
      
    } catch (e) {
      return PostState.serverError;
    }
  }

  getFavoriteTeams() async {
    final String currentUserID = auth.currentUser!.uid;
    List favorite_teams = [
      {
        "names": [],
        "numbers": [],
        "ids": []
      }
    ];
    List favorite_teamsNames = favorite_teams[0]["names"];
    List favorite_teamsNumbers = favorite_teams[0]["numbers"];
    List favorite_teamsIDS = favorite_teams[0]["ids"];

    try {
      final querySnapshot = await firestore
          .collection("Users")
          .doc(currentUserID)
          .collection("favoriteTeams")
          .get();

      for (var doc in querySnapshot.docs) {
        final teamNumber = doc.get("teamNumber");
        final teamName = doc.get("teamName");

        favorite_teamsNumbers.add(teamNumber);
        favorite_teamsNames.add(teamName);
        favorite_teamsIDS.add(doc.id);
      }
      //print(favorite_teamsNumbers);
      //print(favorite_teamsNames);
      //print(favorite_teams[0]["names"][0]);
      return favorite_teams;
    } catch (e) {
      return [];
    }
  }

  
}
