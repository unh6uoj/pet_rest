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
            ),
            body: TabBarView(
              children: [
                ChangeNotifierProvider<LoadCellWebScoket>(
                    create: (_) => LoadCellWebScoket(), child: HomeScreen()),
                ChangeNotifierProvider(
                    create: (_) => VideoWebSocket(), child: VideoScreen()),
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

// Provider Class 생성
// ChangeNotifier를 상속 받음.
// ChangeNotifier는 notifyListeners()함수를 통해 데이터가 변경된 것을 바로 알려줄 수 있다.
class VideoWebSocket extends ChangeNotifier {
  late WebSocketChannel channel;
  bool isVideoOn = false;

  VideoWebSocket() {
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
    channel.sink.add('플러터에서 왔다, 비디오');

    notifyListeners();
  }

  void webSocketDisconnect() {
    channel.sink.close();

    notifyListeners();
  }
}

class LoadCellWebScoket extends ChangeNotifier {
  late WebSocketChannel channel;
  double loadCellDataFood = 0.0;
  double loadCellDataWater = 0.0;

  LoadCellWebScoket() {
    webScoketConnect();
  }

  void webScoketConnect() async {
    channel = IOWebSocketChannel.connect('ws://192.168.0.21:25003');
    channel.sink.add('플러터에서 왔다, 로드셀');

    notifyListeners();
  }

  void webSocketDisconnect() {
    channel.sink.close();

    notifyListeners();
  }
}
