import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_desktop_kit/cdk.dart';
import 'package:flutter_postget/layout_chat.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';

class LayoutDesktop extends StatefulWidget {
  const LayoutDesktop({super.key, required this.title});

  final String title;

  @override
  State<LayoutDesktop> createState() => _LayoutDesktopState();
}

class _LayoutDesktopState extends State<LayoutDesktop> {
  AppData appData = AppData();
  // Return a custom button
  Widget buildCustomButton(String buttonText, VoidCallback onPressedAction) {
    return Column(children: []);
  }

  // Funció per seleccionar un arxiu
  Future<File> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      throw Exception("No s'ha seleccionat cap arxiu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    String stringGet = "";
    if (appData.loadingGet) {
      stringGet = "Loading ...";
    } else if (appData.dataGet != null) {
      stringGet = "GET: ${appData.dataGet.toString()}";
    }

    String stringPost = "";
    if (appData.loadingPost) {
      stringPost = "Loading ...";
    } else if (appData.dataPost != null) {
      stringPost = "GET: ${appData.dataPost.toString()}";
    }

    String stringFile = "";
    if (appData.loadingFile) {
      stringFile = "Loading ...";
    } else if (appData.dataFile != null) {
      stringFile = "File: ${appData.dataFile}";
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Chat IETI"),
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center, // Vertical
      //   children: <Widget>[
      //     Container(
      //       height: 50,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         buildCustomButton('Crida tipus GET', () {
      //           appData.load("GET");
      //         }),
      //         Container(
      //           width: 10,
      //         ),
      //         Expanded(
      //             child: Text(stringGet,
      //                 softWrap: true, overflow: TextOverflow.visible)),
      //       ],
      //     ),
      //     Container(
      //       height: 20,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         buildCustomButton('Crida tipus POST', () {
      //           uploadFile(appData);
      //         }),
      //         Container(
      //           width: 10,
      //         ),
      //         Expanded(
      //             child: Text(stringPost,
      //                 softWrap: true, overflow: TextOverflow.visible)),
      //       ],
      //     ),
      //     Container(
      //       height: 20,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         buildCustomButton('Llegir arxiu .JSON', () {
      //           appData.load("FILE");
      //         }),
      //         Container(
      //           width: 10,
      //         ),
      //         Expanded(
      //             child: Text(stringFile,
      //                 softWrap: true, overflow: TextOverflow.visible)),
      //       ],
      //     ),
      //   ],
      // ),
      child: LayoutChat(),
    );
  }
}
