import 'package:chat_app/components/chat/typing_indicator.dart';
import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {

    var marginOnUser = isCurrentUser ? 
        const EdgeInsets.only(right: 20, top: 5, bottom: 5, left: 75) :
        const EdgeInsets.only(right: 75, top: 5, bottom: 5, left: 20);
    if(message == '-LOADING-'){
      return Container(
        height: 60,
        width: 100,
        child: TypingIndicator(
          showIndicator: true,
        ));
    } else {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      margin: marginOnUser,
      child: SelectableText(message),
    );}
  }
}