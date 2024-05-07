import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';



// ignore: non_constant_identifier_names
class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }
  
  Future<String> uploadImageToStorage(File? imageFile) async {
    if (imageFile == null) {
      throw ArgumentError('imageFile cannot be null');
    }

    try {

      String uniqueFileName = Timestamp.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDir = referenceRoot.child("images");
      Reference referenceImageToUpload = referenceDir.child(uniqueFileName);

      referenceImageToUpload.putFile(imageFile);
      
      print(referenceImageToUpload.getDownloadURL());
      return referenceImageToUpload.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Reenvía el error para manejarlo en otro lugar si es necesario
    }
  }

  Future<void> sendMessage(String recieverId, message) async {
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message messageToSend = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp,
        messageType: MessageType.text);
    
    List<String> ids = [currentUserID, recieverId];
    ids.sort();
    String chatRomID = ids.join("_");

    await firestore
        .collection("chatrooms")
        .doc(chatRomID)
        .collection("messages")
        .add(messageToSend.toMap());
  }

  Future<void> sendImage(String receiverID, imageUrl) async {
    final String currentUserID = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;

    Message messageToSend = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        recieverId: receiverID,
        message: imageUrl,
        timestamp: Timestamp.now(),
        messageType: MessageType.text);
  // Sube la imagen a Firebase Storage y obtén la URL de descarga
  List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRomID = ids.join("_");
  await firestore
    .collection("chatrooms")
    .doc(chatRomID)
    .collection("messages")
    .add(messageToSend.toMap());
  // Crea un nuevo documento en la colección de mensajes con el mensaje y la URL de la imagen
  /*await FirebaseFirestore.instance.collection('messages').add({
    'senderId': auth.currentUser!.uid,
    'receiverId': receiverID,
    'imageUrl': imageUrl,
    'timestamp': FieldValue.serverTimestamp(),
  });*/
}


  Stream<QuerySnapshot> getMessages(String currentUserID, otherUserID) {

    List<String> ids = [currentUserID, otherUserID];
    ids.sort();
    String chatRomID = ids.join("_");

    return firestore
          .collection("chatrooms")
          .doc(chatRomID)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .snapshots();
  }

}
