import 'package:flutter/cupertino.dart';

class ChatImgMessage {
  String prompt;
  String type;
  String image;
  ChatImgMessage(
      {required this.prompt, required this.type, required this.image});
}
