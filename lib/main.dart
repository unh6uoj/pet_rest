import 'package:flutter/material.dart';

import 'screen_home.dart';
import 'screen_video.dart';
import 'screen_info.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Provider
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Station',
      theme: ThemeData(primaryColor: Colors.green),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Pet Station'),
              backgroundColor: Colors.green,
            ),
            body: TabBarView(
              children: [
                ChangeNotifierProvider<LoadCellProvider>(
                    create: (_) => LoadCellProvider(), child: HomeScreen()),
                ChangeNotifierProvider<VideoProvider>(
                    create: (_) => VideoProvider(), child: VideoScreen()),
                InfoScreen()
              ],
            ),
            bottomNavigationBar: TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: 'Home',
                  ),
                  Tab(
                    icon: Icon(Icons.camera_alt_outlined),
                    text: 'Video',
                  ),
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: 'My',
                  )
                ]),
          )),
    );
  }
}

// Provider Class 생성
// ChangeNotifier를 상속 받음.
// ChangeNotifier는 notifyListeners()함수를 통해 데이터가 변경된 것을 바로 알려줄 수 있다.
class VideoProvider extends ChangeNotifier {
  late WebSocketChannel channel;
  bool isVideoOn = false;

  VideoProvider() {
    webScoketConnect();
  }

  void videoOn() {
    isVideoOn = true;

    notifyListeners();
  }

  void videoOff() {
    isVideoOn = false;

    notifyListeners();
  }

  void webScoketConnect() async {
    channel = IOWebSocketChannel.connect('ws://192.168.0.21:25001');
    channel.sink.add('video init');

    notifyListeners();
  }

  void webSocketDisconnect() {
    channel.sink.close();

    notifyListeners();
  }
}

class LoadCellProvider extends ChangeNotifier {
  WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://192.168.1.132:25003');
  double loadCellDataFood = 0.0;
  double loadCellDataWater = 0.0;

  // LoadCellProvider() {
  //   webScoketConnect();
  // }

  // void webScoketConnect() async {
  //   this.channel = IOWebSocketChannel.connect('ws://192.168.1.132:25003');
  //   this.channel.sink.add('mortor init');

  //   notifyListeners();
  // }

  void webSocketDisconnect() {
    this.channel.sink.close();

    notifyListeners();
  }

  void sendFood() {
    this.channel.sink.add('food');
    print('food 보냄');
    notifyListeners();
  }

  void sendWater() {
    this.channel.sink.add('water');
    print('water 보냄');
    notifyListeners();
  }
}
