import 'dart:ffi';

class ChatMessage {
  String messageContent;
  String type;
  String image;
  bool oldMssg;
  ChatMessage(
      {required this.messageContent,
      required this.type,
      required this.image,
      required this.oldMssg});
}
