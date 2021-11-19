import 'package:flutter/material.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';

// getx
import 'package:get/get.dart';

// sqlite
import '../sqlite.dart';

String ip = 'ws://192.168.1.126';

class WebSocketController extends GetxController {
  var dataChannel;
  var motorChannel;
  var videoChannel;

  var isData = false.obs;
  var isBall = false.obs;
  var isVideoOn = false.obs;

  var loadCellDataFood = 0.0.obs;
  var loadCellDataWater = 0.0.obs;

  dataWebSocketConntect() {
    dataChannel = IOWebSocketChannel.connect(ip + ':25002');
  }

  dataWebSocketDisconnect() {
    isData.value = false;
    dataChannel.sink.close();
  }

  dataOn() async {
    dataWebSocketConntect();
    dataChannel.sink.add('data done');

    isData.value = true;
  }

  // 여기는 모터
  motorWebSocketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25001');
  }

  motorWebSocketDisconnect() async {
    motorChannel.value.sink.close();
  }

  sendFood() async {
    motorWebSocketConnect().then((value) => value.sink.add('ball'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '밥주기'));
  }

  sendWater() async {
    motorWebSocketConnect().then((value) => value.sink.add('water'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '물주기'));
  }

  sendBall() async {
    motorWebSocketConnect().then((value) => value.value.sink.add('ball'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '공던지기'));
  }

  // 여기부터 비디오
  videoWebSocketConnect() async {
    videoChannel = IOWebSocketChannel.connect(ip + ':25005');
  }

  videoWebSocketDisconnect() async {
    if (isVideoOn.value) {
      isVideoOn.value = false;
      videoChannel.sink.close();
    }
  }

  videoOn() async {
    videoWebSocketConnect();
    videoChannel.sink.add('on');
    isVideoOn.value = true;
  }

  videoOff() async {
    isVideoOn.value = false;

    videoWebSocketDisconnect();
  }

  disConnectAllWebSocket() {
    dataWebSocketDisconnect();
    motorWebSocketDisconnect();
    videoWebSocketDisconnect();
  }
}
