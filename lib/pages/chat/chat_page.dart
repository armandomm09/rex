// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:ui';

import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:chat_app/components/chat/chat_bubble.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/util/string_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  const ChatPage(
      {super.key, required this.recieverEmail, required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();

  final AuthService authService = AuthService();

  // ignore: avoid_init_to_null
  late File? _imageFile = null;
  var messageToSend;
  var imagePath;

  String initImageURL =
      'https://firebasestorage.googleapis.com/v0/b/chatapp-6866b.appspot.com/o/images%2F1715477348068?alt=media&token=1e1167c1-38f2-4732-8e0b-90400153a88a';

  bool isShowingImageOverlay = false;

  bool startAnimation = false;

  double imageXAlignment = 0;
  double imageYAlignment = 0;

  Widget imageOverlayer = Container();

  void sendMessage() async {
    if (_imageFile != null || messageController.text.isNotEmpty) {
      if (_imageFile != null) {
        try {
          String imageUrl = await chatService.uploadImageToStorage(_imageFile);
          print(imageUrl.toString() + 'holas');
          await chatService.sendMessage(widget.recieverID, imageUrl);
        } catch (e) {
          print('Error sending image: $e');
          // Manejar el error aquí
        }
      } else {
        await chatService.sendMessage(
            widget.recieverID, messageController.text);
      }
      messageController.clear();
      setState(() {
        _imageFile = null;
      });
    }
  }

  analyzeImage(String imageURL) {}

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
  void initState() {
    //moveMessages();
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.primary,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(appBarTitle),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/chat_background.png'))),
        child: Stack(
          children: [
            Positioned.fill(
                child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Color.fromARGB(213, 0, 0, 0),
              ),
            )),
            Column(
              children: [Expanded(child: buildMessageList()), buildUserInput()],
            ),
            imageOverlayer
          ],
        ),
      ),
    );
  }

  setImageOverlay(String url) {
    setState(() {
      imageOverlayer = Stack(children: [
        Positioned.fill(
            child: GestureDetector(
          onTap: () => removeOverlayer,
          child: Container(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        )),
        Center(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: InteractiveViewer(
                  child: Image.network(
                    url,
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 10,
                  child: IconButton(
                    onPressed: removeOverlayer,
                    icon: const Icon(Icons.remove),
                    iconSize: 40,
                    color: Colors.amber,
                  ))
            ],
          ),
        ),
      ]);
    });
  }

  removeOverlayer() {
    print('REMOVING OVERLAYER');
    setState(() {
      imageOverlayer = Container();
    });
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
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      bool isCurrentUser =
          data["senderId"] == authService.getCurrentUser()!.uid;

      var alignment =
          isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!data["message"].toString().contains(
                'firebasestorage.googleapis.com')) // Mostrar el mensaje si existe
              ChatBubble(
                  message: data["message"], isCurrentUser: isCurrentUser),
            if (data["message"].toString().contains(
                'firebasestorage.googleapis.com')) // Mostrar la imagen si existe
              GestureDetector(
                onTap: () {
                  print('SETTING OVERLAY');
                  setImageOverlay(data['message']);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(data['message'], height: 200)),
                  ),
                ),
              ),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  Widget buildUserInput() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Expanded(
            child: _imageFile != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      imagePath,
                      height: 200,
                    )) //Image.file(_imageFile!, height: 200) // Mostrar la imagen seleccionada si existe
                : AppTextField( height: 50,
                    hintText: "Message", controller: messageController, padding: EdgeInsets.symmetric(horizontal: 20),),
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
