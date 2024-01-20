import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'chatMessage.dart';
import 'chatImgMessage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class LayoutChat extends StatefulWidget {
  const LayoutChat({super.key});

  @override
  _LayoutChatState createState() => _LayoutChatState();
}

TextEditingController _controller = TextEditingController();
ScrollController _scrollController = ScrollController();

class _LayoutChatState extends State<LayoutChat> {
  List<String> listPost = [];
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    String stringPost = "";
    if (appData.loadingPost && appData.dataPost == "") {
      stringPost = "Loading ...";
    } else if (appData.dataPost != null) {
      stringPost = appData.dataPost.toString();
      appData.messages[appData.messages.length - 1].messageContent = stringPost;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
    return CupertinoPageScaffold(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 65, 74, 82),
        body: Stack(
          children: <Widget>[
            ListView.builder(
              controller: _scrollController,
              itemCount: appData.messages.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appData.messages[index].type == 'send'
                          ? "You\n${appData.messages[index].messageContent}"
                          : "Chat IETI\n${appData.messages[index].messageContent}",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                );
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
                                  messageContent: _controller.text,
                                  type: "send"))
                              : null;
                        });
                        appData.load('POST', _controller.text);
                        appData.messages.add(
                            ChatMessage(messageContent: "", type: "receive"));
                        _controller.text = "";
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CDKButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          PlatformFile file = result.files.first;
                          Uint8List? fileBytes = file.bytes;
                          if (fileBytes != null) {
                            String base64String = base64Encode(fileBytes);
                            setState(() {
                              if (_controller.text != "") {
                                appData.messages.add(ChatImgMessage(
                                  prompt: _controller.text,
                                  type: "imatge",
                                  image: base64String,
                                ) as ChatMessage);
                              }
                            });
                            // appData.load('POST', _controller.text,
                            //     fileData: base64String);
                            // _controller.text = "";
                          }
                        }
                      },
                      child: const Icon(
                        Icons.attach_file,
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

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
