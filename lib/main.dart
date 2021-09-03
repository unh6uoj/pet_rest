import 'package:flutter/material.dart';

import 'screen_home.dart';
import 'screen_video.dart';
import 'screen_info.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebSocketChannel channel =
        IOWebSocketChannel.connect('ws://192.168.0.12:25001');

    return MaterialApp(
      title: 'Pet Station',
      theme: ThemeData(primaryColor: Colors.green),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Pet Station'),
            ),
            body: TabBarView(
              children: [
                HomeScreen(),
                VideoScreen(channel: channel),
                InfoScreen()
              ],
            ),
            bottomNavigationBar: TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                    text: 'Home',
                  ),
                  Tab(
                    icon: Icon(Icons.video_camera_front),
                    text: 'Video',
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: 'My',
                  )
                ]),
          )),
    );
  }
}
