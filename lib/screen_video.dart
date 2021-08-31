import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String serverIP = "";
  int port = 250001;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        ElevatedButton(onPressed: () {}, child: Text('비디오 나와라')),
        ElevatedButton(onPressed: () {}, child: Text('비디오 꺼져라'))
      ],
    ));
  }
}
