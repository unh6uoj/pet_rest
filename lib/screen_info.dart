import 'package:flutter/material.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Provider
import 'package:provider/provider.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WebScoketConnection>(
        create: (_) => WebScoketConnection(),
        child: Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LoadCellInfo(), LoadCellController()],
          ),
        )));
  }
}

class LoadCellInfo extends StatefulWidget {
  const LoadCellInfo({Key? key}) : super(key: key);

  @override
  _LoadCellInfoState createState() => _LoadCellInfoState();
}

class _LoadCellInfoState extends State<LoadCellInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 250,
        // watch() 함수를 통해 데이터 접근
        // watch()는 UI를 바로 업데이트 함
        child: context.watch<WebScoketConnection>().isLoadCellConnect
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
                          child: Text(snapshot.data as String)));
                },
              ))
            : Container());
  }
}

class LoadCellController extends StatefulWidget {
  const LoadCellController({Key? key}) : super(key: key);

  @override
  _LoadCellControllerState createState() => _LoadCellControllerState();
}

class _LoadCellControllerState extends State<LoadCellController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          // provider 데이터 접근
          context.read<WebScoketConnection>().webScoketConnect();
        },
        child: Text('Con'),
      ),
    );
  }
}

// Provider Class 생성
// ChangeNotifier를 상속 받음.
// ChangeNotifier는 notifyListeners()함수를 통해 데이터가 변경된 것을 바로 알려줄 수 있다.
class WebScoketConnection extends ChangeNotifier {
  late WebSocketChannel channel;
  bool isLoadCellConnect = false;

  void webScoketConnect() async {
    channel = IOWebSocketChannel.connect('ws://192.168.1.135:25003');
    channel.sink.add('플러터에서 왔다.');
    isLoadCellConnect = true;

    notifyListeners();
  }

  void webSocketDisconnect() {
    isLoadCellConnect = false;
    channel.sink.close();

    notifyListeners();
  }
}
