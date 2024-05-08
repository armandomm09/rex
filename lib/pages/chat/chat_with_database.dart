import 'package:chat_app/components/chat/chat_bubble.dart';
import 'package:chat_app/components/forms/app_text_field.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/openai/scout_gpt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatWithDatabase extends StatefulWidget {
  const ChatWithDatabase({super.key});

  @override
  State<ChatWithDatabase> createState() => _ChatWithDatabaseState();
}

class _ChatWithDatabaseState extends State<ChatWithDatabase> {
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  final AuthService authService = AuthService();

  @override
  void initState(){
    focusNode.addListener(() {
      if(focusNode.hasFocus){

        Future.delayed(const Duration(milliseconds: 500),
        () => scrollDown());
      }
    });
    super.initState();
  }

  @override
  void dispose(){ 
    focusNode.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
  scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.bounceInOut);
  }

  askGptFromDB() async {
    print('Asking..');
    print(await ScoutGPTService.askGPT("En que lenguaje programa lambot?"));
  }

  TextEditingController messageController = TextEditingController();

  buildUserInput() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              focusNode: focusNode,
              hintText: "Message",
              controller: messageController,
            ),
          ),
          
          Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              height: 70,
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(
                onPressed: () {
                  ScoutGPTService.newGptMessage(messageController.text);
                  messageController.text = '';
                },
                icon: const Icon(
                  Icons.send,
                ),
              ))
        ],
      ),
    );
  }

  buildMessageList() {
    return StreamBuilder(
        
        stream: ScoutGPTService.getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("There was an error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            controller: scrollController,
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
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["question"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.primary,
        elevation: 50,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const AppText(
          text: "Scout GPT",
          textColor: TextColor.red,
          fontSize: 28,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessageList()), 
            buildUserInput()
            ]
      ),
    );
  }
}
