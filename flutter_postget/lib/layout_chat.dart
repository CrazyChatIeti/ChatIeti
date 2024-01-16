import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'chatMessage.dart';

class LayoutChat extends StatefulWidget {
  @override
  _LayoutChatState createState() => _LayoutChatState();
}

List<ChatMessage> messages = [
  ChatMessage(
      messageContent:
          "Tengo cuatro casas que mostrarte y la verdad es que me estoy haciendo caca encima",
      messageType: "receiver"),
  ChatMessage(messageContent: "adios", messageType: "receiver"),
  ChatMessage(messageContent: "que tal", messageType: "sender"),
  ChatMessage(messageContent: "no tu", messageType: "sender"),
  ChatMessage(messageContent: "tonto", messageType: "sender"),
];

class _LayoutChatState extends State<LayoutChat> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 65, 74, 82),
        body: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 80),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 10),
                    child: Align(
                        child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                    )));
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 80,
                width: 700,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    const Expanded(
                        child: CDKFieldText(
                      textSize: 18,
                      isRounded: true,
                      placeholder: "Ask ChatIeti...",
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    CDKButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
