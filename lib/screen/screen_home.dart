import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet/main.dart';

import 'dart:typed_data';

// drawer
import 'package:pet/drawer.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// persent_indicator
import 'package:percent_indicator/percent_indicator.dart';

// getx
import 'package:get/get.dart';

// sqlite
import '../sqlite.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('홈'), backgroundColor: Colors.green[500]),
        drawer: myDrawer,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VideoArea(),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: HomeDataCard(
                        name: '밥',
                        isLinear: false,
                        sendFunc: homeScreenController.sendFood,
                      )),
                      Expanded(
                          child: HomeDataCard(
                        name: '물',
                        isLinear: false,
                        sendFunc: homeScreenController.sendWater,
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: HomeDataCard(
                        name: '활동량',
                        isLinear: false,
                        sendFunc: homeScreenController.sendFood,
                      )),
                      Expanded(
                          child: HomeDataCard(
                        name: '공',
                        isLinear: false,
                        sendFunc: homeScreenController.sendWater,
                      )),
                    ],
                  )
                ])));
  }
}

class VideoArea extends StatelessWidget {
  VideoArea({Key? key}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 340,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: FractionallySizedBox(
                widthFactor: 1,
                child: Obx(
                  () => Container(
                      child: homeScreenController.isVideoOn.value
                          ? StreamBuilder(
                              // read() 함수를 통해 데이터 접근
                              // read()는 UI업데이트 하지 않음. 여기선 stream으로 값을 받아오기 때문에
                              // UI업데이트는 자동으로 된다.
                              stream: homeScreenController
                                  .videoChannel.value.stream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                    onPressed: () =>
                                        homeScreenController.videoOff,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white),
                                    child: Image.memory(
                                      snapshot.data as Uint8List,
                                      gaplessPlayback:
                                          true, // gaplessPlayback을 true로 하지 않으면 이미지 변경 될 때 마다 깜빡깜빡 한다.
                                    ));
                              })
                          : Container(
                              color: Colors.black,
                              child: IconButton(
                                onPressed: homeScreenController.videoOn,
                                icon: Icon(Icons.play_arrow),
                                color: Colors.white,
                                iconSize: 72,
                              ))),
                ))));
  }
}

class HomeDataCard extends StatelessWidget {
  HomeDataCard(
      {Key? key,
      required this.name,
      required this.isLinear,
      required this.sendFunc})
      : super(key: key);

  final String name;
  final bool isLinear;
  final sendFunc;

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(
                onTap: () {
                  homeScreenController.bottomSheetText.value =
                      '여기를 누르면 $name을 줄 수 있어요';
                  Get.bottomSheet(
                      BottomSheetForSendData(name: name, sendFunc: sendFunc));
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: Offset(0, 3),
                              color: Colors.grey.withOpacity(0.4))
                        ]),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              name,
                              textScaleFactor: 1.3,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        PercentBar(
                          isLinear: this.isLinear,
                        ),
                      ],
                    )))));
  }
}

class BottomSheetForSendData extends StatelessWidget {
  BottomSheetForSendData({Key? key, required this.name, required this.sendFunc})
      : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final String name;
  final sendFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          homeScreenController.bottomSheetText.value = '$name을 줬어요!';
          this.sendFunc();

          Future.delayed(Duration(seconds: 1)).then((value) => Get.back());
        },
        child: Container(
            height: 120,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Obx(() => Text(
                        homeScreenController.bottomSheetText.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))
                ])));
  }
}

// 퍼센트 바
class PercentBar extends StatefulWidget {
  const PercentBar({Key? key, this.isLinear = true}) : super(key: key);

  final bool? isLinear;

  @override
  _PercentBarState createState() => _PercentBarState(this.isLinear as bool);
}

class _PercentBarState extends State<PercentBar> {
  // 데이터 전달받기
  final bool isLinear;

  _PercentBarState(this.isLinear);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    // 최대 칼로리
    const double maxCalorie = 100;
    double foodData = homeScreenController.loadCellDataFood;
    // 선형/비선형 퍼센트 바 반환
    return this.isLinear
        // 선형 퍼센트 바
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            padding: EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
                animation: true,
                animateFromLastPercent: true, // 이전 퍼센트에서 애니메이션 재생
                animationDuration: 1000,
                lineHeight: 20.0,
                percent: foodData,
                center: Text((foodData * 100).toStringAsFixed(1).toString()),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.lightGreen[500]))

        // 비선형(원형) 퍼센트 바
        : Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            padding: EdgeInsets.all(5.0),
            child: CircularPercentIndicator(
                animation: true,
                animateFromLastPercent: true, // 이전 퍼센트에서 애니메이션 재생
                animationDuration: 1000,
                radius: 100.0,
                lineWidth: 12.0,
                backgroundColor: Colors.white70,
                percent: foodData,
                center: new Text((foodData * 100).toString() + '%',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.lightGreen[700]));
  }
}

class HomeScreenController extends GetxController {
  var motorChannel;
  var videoChannel;
  var bottomSheetText = ''.obs;

  var isVideoOn = false.obs;

  double loadCellDataFood = 0.0;
  double loadCellDataWater = 0.0;

  String ip = 'ws://192.168.1.196';

  Future<Rx<IOWebSocketChannel>> motorWebScoketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25001').obs;
  }

  Future<Rx<IOWebSocketChannel>> videoWebSocketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25005').obs;
  }

  videoWebSocketDisconnect() {
    videoChannel.value.sink.close();
  }

  loadCellWebSocketDisconnect() {
    motorChannel.value.sink.close();
  }

  videoOn() {
    videoWebSocketConnect().then((channel) {
      videoChannel = channel;

      isVideoOn.value = true;

      channel.value.sink.add('on');
    });
  }

  videoOff() {
    isVideoOn.value = false;

    this.videoChannel.value.sink.add('off');
    videoWebSocketDisconnect();
    print('video off');
  }

  sendFood() {
    motorWebScoketConnect().then((value) => value.value.sink.add('food'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '밥주기'));
  }

  sendWater() {
    motorWebScoketConnect().then((value) => value.value.sink.add('water'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '물주기'));
  }

  sendBall() {
    motorWebScoketConnect().then((value) => value.value.sink.add('ball'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '공던지기'));
  }
}
