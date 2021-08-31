import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String serverIP = "";
  int port = 25001;
  String sendStr = "";

  TextEditingController ipCon = TextEditingController();

  Socket clientSocket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        infoArea(),
        ElevatedButton(onPressed: connect, child: Text('비디오 나와라')),
        ElevatedButton(onPressed: disconnect, child: Text('비디오 꺼져라')),
        // Image.memory(bytes)
      ],
    )));
  }

  Widget infoArea() {
    return Card(
      child: ListTile(
          dense: true,
          leading: Text("Server IP"),
          title: TextField(
            controller: ipCon,
            decoration: InputDecoration(
                hintText: "서버 IP를 입력하세요.",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.green)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.green))),
          )),
    );
  }

  void connect() async {
    Socket.connect(ipCon.text, port, timeout: Duration(seconds: 5))
        .then((socket) {
      setState(() {
        clientSocket = socket;
      });
    });

    print('connected!');

    clientSocket.add(utf8.encode(sendStr));
    await Future.delayed(Duration(seconds: 5));

    clientSocket.listen((List<int> event) {
      print(event.length);
    });

    clientSocket.close();
  }

  void disconnect() async {}
}
