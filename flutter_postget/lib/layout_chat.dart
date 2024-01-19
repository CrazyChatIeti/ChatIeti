import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'chatMessage.dart';

class LayoutChat extends StatefulWidget {
  @override
  _LayoutChatState createState() => _LayoutChatState();
}

TextEditingController _controller = TextEditingController();

class _LayoutChatState extends State<LayoutChat> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    String stringPost = "";
    if (appData.loadingPost && appData.dataPost == "") {
      stringPost = "Loading ...";
    } else if (appData.dataPost != null) {
      stringPost = appData.dataPost.toString();
    }
    return CupertinoPageScaffold(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 65, 74, 82),
        body: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 10),
                child: Align(
                    child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    stringPost,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 15),
                  ),
                ))),
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
                    Expanded(
                        child: CDKFieldText(
                      controller: _controller,
                      textSize: 18,
                      isRounded: true,
                      placeholder: "Ask ChatIeti...",
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    CDKButton(
                      onPressed: () {
                        setState(() {
                          _controller.text != ""
                              ? appData.messages.add(ChatMessage(
                                  prompt: _controller.text, type: "conversa"))
                              : null;
                        });
                        appData.load('POST', _controller.text);
                        _controller.text = "";
                      },
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
