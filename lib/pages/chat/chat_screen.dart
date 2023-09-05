
import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:photo_snap/pages/chat/threedot.dart';
import 'package:velocity_x/velocity_x.dart';
import 'chatmessages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
   OpenAI?chatGPT;
   bool _isTyping = false;

   StreamSubscription? _subscription;

@override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
  _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage(){
    ChatMessage _message = ChatMessage(text: _controller.text, sender: "user");
    setState(() {
     /* _isTyping  = true;*/
      _messages.insert(0, _message);
    });
    _controller.clear();

    final   request = CompleteText(
        prompt:_message.text,
        maxTokens: 200,
        model: TextDavinci3Model());

    _subscription =   chatGPT?.build(token: "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").onCompletion(request: request).asStream()
     .listen((response) {
       print(response!.choices[0].text);
     ChatMessage botMessage =ChatMessage(text: response!.choices[0].text, sender: "bot");
setState(() {
/*  _isTyping  = false;*/
  _messages.insert(0, botMessage);

});

   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(child: ListView.builder(
                reverse: true,
                padding:Vx.m8,itemCount:_messages.length,itemBuilder: (context, index) {
              return _messages[index];
            })),
            if(_isTyping)const ThreeDots(),
            const Divider(height: 1.0,),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildTextComposer() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted:(value) => _sendMessage(),
              decoration:
              const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(onPressed: () =>_sendMessage(), icon: const Icon(Icons.send))
        ],
      ),
    );
  }

}
