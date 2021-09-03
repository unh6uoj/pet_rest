import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key, @required this.channel}) : super(key: key);

  final WebSocketChannel? channel;
  static bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          VideoArea(channel: this.channel),
          VideoController(channel: this.channel)
        ],
      ),
    ));
  }
}

class VideoArea extends StatefulWidget {
  const VideoArea({Key? key, @required this.channel}) : super(key: key);
  final WebSocketChannel? channel;

  @override
  _VideoAreaState createState() =>
      _VideoAreaState(this.channel as WebSocketChannel);
}

class _VideoAreaState extends State<VideoArea> {
  final WebSocketChannel channel;

  _VideoAreaState(this.channel);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: VideoScreen.isConnected
            ? StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Container(
                          width: 350,
                          height: 200,
                          color: Colors.black,
                          child: Image.memory(
                            snapshot.data as Uint8List,
                            gaplessPlayback:
                                true, // gaplessPlayback을 true로 하지 않으면 이미지 변경 될 때 마다 깜빡깜빡 한다.
                          )));
                },
              )
            : Text("no"));
  }
}

class VideoController extends StatefulWidget {
  const VideoController({Key? key, @required this.channel}) : super(key: key);
  final WebSocketChannel? channel;

  @override
  _VideoControllerState createState() =>
      _VideoControllerState(this.channel as WebSocketChannel);
}

class _VideoControllerState extends State<VideoController> {
  final WebSocketChannel channel;
  _VideoControllerState(this.channel);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: websocketConnect,
              child: Text('비디오 나와라')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {},
              child: Text('비디오 꺼져라')),
        ],
      ),
    );
  }

  void websocketConnect() async {
    // 서버로 데이터 보내는 부분
    this.channel.sink.add('플러터에서 왔다.');

    setState(() {
      VideoScreen.isConnected = true;
    });
  }

  void websocketDisconnect() {
    // channel.sink.close();

    setState(() {
      VideoScreen.isConnected = false;
    });
  }
}
