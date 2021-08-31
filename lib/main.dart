import 'package:flutter/material.dart';

import 'screen_home.dart';
import 'screen_video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat used firebase',
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
                VideoScreen(),
                Text('마이 스크린'),
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
