import 'dart:io';

import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:chat_app/components/chat/chat_bubble.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  const ChatPage({super.key, required this.recieverEmail, required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  late File? _imageFile;
  var messageToSend;
  var imagePath;


  void sendMessage() async {if (_imageFile != null || messageController.text.isNotEmpty) {
    if (_imageFile != null) {
      try {
        String imageUrl = await chatService.uploadImageToStorage(_imageFile);
        print(imageUrl);
        await chatService.sendMessage(widget.recieverID, imageUrl);
      } catch (e) {
        print('Error sending image: $e');
        // Manejar el error aquí
      }
    } else {
      await chatService.sendMessage(widget.recieverID, messageController.text);
    }
    messageController.clear();
    setState(() {
      _imageFile = null;
    });
  }
}




  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
      imagePath = pickedFile?.path;
      print(imagePath);

      //messageToSend =
    });
  }

@override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    messageToSend =
        AppTextField(hintText: "Message", controller: messageController);

    String appBarTitle = StringUtil.slitEmailString(widget.recieverEmail);
    appBarTitle = StringUtil.toTitleCase(appBarTitle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.primary,
        elevation: 50,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(appBarTitle),
      ),
      body: Column(
        children: [Expanded(child: buildMessageList()), buildUserInput()],
      ),
    );
  }

  Widget buildMessageList() {
    String senderID = authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatService.getMessages(senderID, widget.recieverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("There was an error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  bool isCurrentUser = data["senderId"] == authService.getCurrentUser()!.uid;

  var alignment =
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Column(
      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (data.containsKey("message")) // Mostrar el mensaje si existe
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        if (data.containsKey("imageUrl")) // Mostrar la imagen si existe
          Image.network(data["imageUrl"], height: 200),
      ],
    ),
  );
}


  Widget buildUserInput() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          Expanded(
            child: _imageFile != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(imagePath, height: 200,)) //Image.file(_imageFile!, height: 200) // Mostrar la imagen seleccionada si existe
                : AppTextField(
                    hintText: "Message", controller: messageController),
          ),
          IconButton(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.image),
          ),
          Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              height: 70,
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                ),
              ))
        ],
      ),
    );
  }
}
