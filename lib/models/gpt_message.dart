import 'package:cloud_firestore/cloud_firestore.dart';

class GptMessage{

  final String senderId;
  final String senderEmail;
  final String question;
  final String uuid;
  final Timestamp timestamp;

  GptMessage(this.senderId, this.senderEmail, this.question, this.timestamp, this.uuid);

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "question": question,
      "uuid": uuid,
      "timestamp": timestamp
    };
  }
}