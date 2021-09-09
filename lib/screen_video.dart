import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Provider
import 'package:provider/provider.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider 생성
    // 자식 클래스에서 접근이 가능하다.
    return ChangeNotifierProvider<WebScoketConnection>(
        create: (_) => WebScoketConnection(),
        child: Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[VideoArea(), VideoController()],
          ),
        )));
  }
}

class VideoArea extends StatefulWidget {
  const VideoArea({Key? key}) : super(key: key);

  @override
  _VideoAreaState createState() => _VideoAreaState();
}

class _VideoAreaState extends State<VideoArea> {
  _VideoAreaState();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 250,
        // watch() 함수를 통해 데이터 접근
        // watch()는 UI를 바로 업데이트 함
        child: context.watch<WebScoketConnection>().isVideoConnect
            ? Container(
                child: StreamBuilder(
                // read() 함수를 통해 데이터 접근
                // read()는 UI업데이트 하지 않음. 여기선 stream으로 값을 받아오기 때문에
                // UI업데이트는 자동으로 된다.
                stream: context.read<WebScoketConnection>().channel.stream,
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
              ))
            : Container());
  }
}

class VideoController extends StatefulWidget {
  const VideoController({Key? key}) : super(key: key);

  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  _VideoControllerState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                // provider 데이터 접근
                context.read<WebScoketConnection>().webScoketConnect();
              },
              child: Text('비디오 나와라')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                // provider 데이터 접근
                context.read<WebScoketConnection>().webSocketDisconnect();
              },
              child: Text('비디오 꺼져라')),
        ],
      ),
    );
  }
}

// Provider Class 생성
// ChangeNotifier를 상속 받음.
// ChangeNotifier는 notifyListeners()함수를 통해 데이터가 변경된 것을 바로 알려줄 수 있다.
class WebScoketConnection extends ChangeNotifier {
  late WebSocketChannel channel;
  bool isVideoConnect = false;

  void webScoketConnect() async {
    channel = IOWebSocketChannel.connect('ws://192.168.1.192:25001');
    channel.sink.add('플러터에서 왔다.');
    isVideoConnect = true;

    notifyListeners();
  }

  void webSocketDisconnect() {
    isVideoConnect = false;
    channel.sink.close();

    notifyListeners();
  }
}
