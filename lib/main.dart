import 'package:flutter/material.dart';

import 'screen_home.dart';
import 'screen_log.dart';
import 'screen_info.dart';

import 'sqlite.dart';

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
      color: Colors.lightGreen[50],
      title: 'Pet Station',
      theme: ThemeData(primaryColor: Colors.green),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                title: Text('Pet Station'),
                backgroundColor: Colors.green[500],
                leading: Icon(Icons.menu)),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ChangeNotifierProvider<HomeProvider>(
                    create: (_) => HomeProvider(), child: HomeScreen()),
                LogScreen(),
                InfoScreen()
              ],
            ),
            bottomNavigationBar: TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: '홈',
                  ),
                  Tab(
                    icon: Icon(Icons.list_alt),
                    text: '로그',
                  ),
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: '정보',
                  )
                ]),
          )),
    );
  }
}

// Provider Class 생성
// ChangeNotifier를 상속 받음.
// ChangeNotifier는 notifyListeners()함수를 통해 데이터가 변경된 것을 바로 알려줄 수 있다.
class HomeProvider extends ChangeNotifier {
  late WebSocketChannel videoChannel;
  late WebSocketChannel motorChannel;

  bool isVideoOn = false;

  double loadCellDataFood = 0.0;
  double loadCellDataWater = 0.0;

  HomeProvider() {
    motorWebScoketConnect();
    // videoWebSocketConnect();
  }

  void motorWebScoketConnect() async {
    this.motorChannel = IOWebSocketChannel.connect('ws://192.168.1.132:25005');
    this.motorChannel.sink.add('mortor init');

    notifyListeners();
  }

  void videoWebSocketConnect() async {
    this.videoChannel = IOWebSocketChannel.connect('ws://192.168.1.132:25001');
    this.videoChannel.sink.add('video init');

    notifyListeners();
  }

  void videoWebSocketDisconnect() {
    this.videoChannel.sink.close();

    notifyListeners();
  }

  void loadCellWebSocketDisconnect() {
    this.motorChannel.sink.close();

    notifyListeners();
  }

  void videoOn() {
    videoWebSocketConnect();

    isVideoOn = true;

    this.videoChannel.sink.add('on');
    print('video on');

    notifyListeners();
  }

  void videoOff() {
    isVideoOn = false;

    this.videoChannel.sink.add('off');
    videoWebSocketDisconnect();
    print('video off');

    notifyListeners();
  }

  void sendFood() {
    this.motorChannel.sink.add('food');
    print('food 보냄');
    notifyListeners();
  }

  void sendWater() {
    this.motorChannel.sink.add('water');
    print('water 보냄');
    notifyListeners();
  }

  void sendBall() {
    this.motorChannel.sink.add('ball');
    print('ball 보냄');
    notifyListeners();
  }
}
