import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String serverIP = "";
  int port = 25001;

  String sendStr = "";

  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://localhost:25001');

  Queue imageQueue = Queue();

  TextEditingController ipCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(onPressed: websocketConnect, child: Text('비디오 나와라')),
        ElevatedButton(onPressed: websocketDisconnect, child: Text('비디오 꺼져라')),
        StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: snapshot.hasData
                    ? Image.memory(snapshot.data as Uint8List)
                    : Text('Websocket Disconnected'));
          },
        )
      ],
    )));
  }

  void printData(str) {
    Uint8List.fromList([0]);
    print(str);
  }

  void websocketConnect() {
    channel.sink.add('플러터에서 왔다.');
  }

  void getImageFromWebsocket() async {
    while (true) {
      imageQueue.add(channel.stream);
    }
  }

  void websocketDisconnect() {
    channel.sink.close();
  }
}
