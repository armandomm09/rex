import 'package:chat_app/constants.dart';
import 'package:chat_app/models/gpt_message.dart';
import 'package:chat_app/services/firebase/scout_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssh2/ssh2.dart';
import 'package:uuid/uuid.dart';

class ScoutGPTService{

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final String currentUserID = auth.currentUser!.uid;
  static final String currentUserEmail= auth.currentUser!.email!;


  static newGptMessage(String question) async {

    final GptMessage message = GptMessage(currentUserID, currentUserEmail, question, Timestamp.now(), Uuid().v1());

    try {
      await firestore
      .collection('Users')
      .doc(currentUserID)
      .collection('gptChat')
      .add(message.toMap());
      print('Sent succesfull');
      //newGPTAnswer(question);
      newGPTAnswer(question);
      return PostState.successful;
    } catch (e) {
      print('Error at $e');
      return PostState.serverError;
    }
  }
  static Future<String> askGPT(String question) async {

    final ssh = SSHClient(
      host: sshHost,
      port: sshPort, 
      username: sshUsername, 
      passwordOrKey: sshPassword);

    try {
      await ssh.connect();
      String? result = await ssh.execute('python3 scouting/scout_gpt/run.py "$question"');
      return result!;
    } catch (e) {
      return 'Sorry, there was a problem: $e';
    }
  }

  static newGPTAnswer(String question) async {
    try {
      String loadingMessageUuid = Uuid().v1();
      GptMessage loadingMessage = GptMessage('chatGPT', 'chatGPT@imperator.com', "-LOADING-", Timestamp.now(), loadingMessageUuid);
      await firestore
      .collection('Users')
      .doc(currentUserID)
      .collection('gptChat')
      .add(loadingMessage.toMap());

      String answer = await askGPT(question);

      GptMessage message = GptMessage('chatGPT', 'chatGPT@imperator.com', answer.trim(), Timestamp.now(), loadingMessageUuid);

      var docsWithUuid = await firestore
      .collection('Users')
      .doc(currentUserID)
      .collection('gptChat')
      .where('uuid', isEqualTo: loadingMessageUuid)
      .limit(1)
      .get();

      docsWithUuid.docs.forEach((doc) async {
        await firestore
      .collection('Users')
      .doc(currentUserID)
      .collection('gptChat')
      .doc(doc.id)
      .update(message.toMap());
      });
      
      
    } catch (e) {
      print('Error on newGPTAnswer at $e');
    }
    
  }

  static Stream<QuerySnapshot> getMessages() {


    return firestore
          .collection("Users")
          .doc(currentUserID)
          .collection("gptChat")
          .orderBy("timestamp", descending: false)
          .snapshots();
  }
  
}