import 'package:flutter/material.dart';

import 'dart:typed_data';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';

// getx
import 'package:get/get.dart';

// sqlite
import '../sqlite.dart';

// wave
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

// fl_chart
import 'package:fl_chart/fl_chart.dart';

String ip = 'ws://192.168.1.126';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  HomeScreen({Key? key}) : super(key: key) {
    // homeScreenController.dataWebSocketConntect();
    homeScreenController.dataOn();
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '홈',
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      VideoArea(),
                      homeScreenController.isData.value
                          ? StreamBuilder(
                              stream: homeScreenController.dataChannel.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  homeScreenController.setData(snapshot.data);
                                }
                                return Column(children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        WavePercent(
                                          name: '밥',
                                          percent: homeScreenController
                                              .loadCellDataFood,
                                          sendFunc:
                                              homeScreenController.sendFood,
                                        ),
                                        SizedBox(width: 10),
                                        WavePercent(
                                          name: '물',
                                          percent: homeScreenController
                                              .loadCellDataWater,
                                          sendFunc:
                                              homeScreenController.sendWater,
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BallCard(
                                      sendFunc: homeScreenController.sendBall),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MoveCheckCard(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]);
                              })
                          : SizedBox(),
                    ]))));
  }
}

class VideoArea extends StatelessWidget {
  VideoArea({Key? key}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 305,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Obx(() => Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  clipBehavior: Clip.hardEdge,
                  child: homeScreenController.isVideoOn.value
                      ? InkWell(
                          onTap: () => homeScreenController.videoOff(),
                          child: StreamBuilder(
                              stream: homeScreenController
                                  .videoChannel.value.stream,
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? Image.memory(
                                        snapshot.data as Uint8List,
                                        gaplessPlayback:
                                            true, // gaplessPlayback을 true로 하지 않으면 이미지 변경 될 때 마다 깜빡깜빡 한다.
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                            Image.asset(
                                              'images/peterest_logo.png',
                                              width: 150,
                                            ),
                                            Text(
                                              '서버 상태가 좋지 않아요ㅠㅠ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  homeScreenController.videoOn,
                                              icon:
                                                  Icon(Icons.replay, size: 35),
                                              color: Colors.white,
                                            ),
                                          ]);
                              }))
                      : IconButton(
                          onPressed: homeScreenController.videoOn,
                          icon: Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 72,
                        ))),
            )));
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
                color: Color(0xFF08D57F).withOpacity(0.5),
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

class WavePercent extends StatelessWidget {
  WavePercent({Key? key, required this.name, this.percent, this.sendFunc})
      : super(key: key);

  final name;
  final percent;
  final sendFunc;

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(children: <Widget>[
          Container(
            // Clip.hardEdge를 적용하면 child위젯이 Container크기에 맞춰서 가져짐
            // overflow: hidden 과 비슷한듯
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: Offset(0, 3),
                      color: Colors.grey.withOpacity(0.4))
                ]),
            child: InkWell(
                onTap: () {
                  homeScreenController.bottomSheetText.value =
                      '여기를 누르면 $name을 줄 수 있어요';
                  Get.bottomSheet(
                      BottomSheetForSendData(name: name, sendFunc: sendFunc));
                },
                child: WaveWidget(
                  config: name == '밥'
                      ? CustomConfig(
                          gradients: [
                            [Color(0xffDFB796), Color(0xEEF44336)],
                            [Color(0xffEEDFD3), Color(0x77E57373)],
                            [Colors.orange, Color(0x66FF9800)],
                            [Color(0xffE4DFB1), Color(0x55FFEB3B)]
                          ],
                          durations: [36000, 19000, 12000, 8000],
                          heightPercentages: [
                            0.86 - percent.value,
                            0.87 - percent.value,
                            0.88 - percent.value,
                            0.89 - percent.value,
                          ],
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        )
                      : CustomConfig(
                          gradients: [
                            [Color(0xffEDEDEF), Color(0xff6767FB)],
                            [Color(0xffB6B6BC), Color(0xff0000FF)],
                            [Color(0xffD8D8DF), Color(0xff4F4FA9)],
                            [Color(0xffC2C2C7), Color(0xff4141E8)]
                          ],
                          durations: [33000, 17000, 12000, 5000],
                          heightPercentages: [
                            0.86 - percent.value,
                            0.87 - percent.value,
                            0.88 - percent.value,
                            0.89 - percent.value
                          ],
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                  waveAmplitude: name == '밥' ? -5 : 5,
                  size: Size(182, 250),
                )),
          ),
          Container(
              width: 182,
              height: 250,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(name),
                    SizedBox(height: 180),
                    Text(
                      (percent.value * 100).toString() + '%',
                      style: TextStyle(fontSize: 22),
                    ),
                  ]))
        ]));
  }
}

class BallCard extends StatelessWidget {
  BallCard({Key? key, required this.sendFunc}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final sendFunc;

  @override
  Widget build(BuildContext context) {
    return Obx(() => FractionallySizedBox(
        widthFactor: 0.95,
        child: InkWell(
            onTap: () {
              homeScreenController.bottomSheetText.value =
                  '여기를 누르면 공을 날릴 수 있어요';

              homeScreenController.isBall.value
                  ? Get.bottomSheet(
                      BottomSheetForSendData(name: '공', sendFunc: sendFunc))
                  : Get.snackbar('공이 없어요', 'pet station에 공을 넣어주세요',
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      backgroundColor: Color(0xFF17D282));
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Color(0xFF17D282),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: Offset(0, 3),
                        color: Colors.grey.withOpacity(0.4))
                  ]),
              child: Row(children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(45),
                    child: homeScreenController.isBall.value
                        ? Image.asset('images/ball_on.png')
                        : Image.asset('images/ball_off.png')),
                homeScreenController.isBall.value
                    ? Text(
                        '공이 있어요',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        '공이 없어요',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
              ]),
            ))));
  }
}

class MoveCheckCard extends StatelessWidget {
  MoveCheckCard({Key? key}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final List<String> today = DateTime.now().toString().split(' ')[0].split('-');

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                child: Text(
                  '${today[0]}년 ${today[1]}월 ${today[2]}일',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
            Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Color(0xFF17D282),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 0.5,
                          offset: Offset(0, 3),
                          color: Colors.grey.withOpacity(0.4))
                    ]),
                child: Obx(() => Padding(
                    padding: EdgeInsets.all(10),
                    child: BarChart(
                      BarChartData(
                          barGroups: homeScreenController.barChartList,
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(touchTooltipData:
                              BarTouchTooltipData(getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                            String hour;
                            hour = (group.x.toInt() + 1).toString() + '시';

                            return BarTooltipItem(
                                hour + '\n',
                                const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(text: (rod.y).toString())
                                ]);
                          })),
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: SideTitles(showTitles: true),
                              topTitles: SideTitles(showTitles: false),
                              rightTitles: SideTitles(showTitles: false),
                              bottomTitles: SideTitles(showTitles: false))),
                    )))),
          ],
        ));
  }
}

class HomeScreenController extends GetxController {
  var dataChannel;
  var motorChannel;
  var videoChannel;

  var isData = false.obs;
  var isBall = false.obs;
  var isVideoOn = false.obs;

  var loadCellDataFood = 0.0.obs;
  var loadCellDataWater = 0.0.obs;

  var ballText = '공이 없어요'.obs;
  var bottomSheetText = ''.obs;

  var momentDataList = [].obs;
  var barChartList = RxList<BarChartGroupData>();

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

  getChartData() {
    List<BarChartGroupData> tempList = [];

    // barChartDataList에 값 넣기
    this.momentDataList.asMap().forEach((key, value) {
      tempList.add(BarChartGroupData(x: key - 1, barRods: [
        BarChartRodData(
            y: double.parse(value) * 5.5, width: 10, colors: [Colors.white])
      ]));
    });

    barChartList.value = tempList;
  }

  setData(receivedData) {
    // 데이터 전처리
    List<dynamic> sensorData = receivedData.toString().split('[')[0].split(',');
    List<dynamic> cameraData =
        (receivedData.toString().split('[')[1]).replaceAll(']', '').split(',');

    loadCellDataFood.value = double.parse(sensorData[0]);
    loadCellDataWater.value = double.parse(sensorData[1]);
    isBall.value = sensorData[2] == 'True';
    momentDataList.value = cameraData;

    getChartData();
  }

  // 여기는 모터
  Future<Rx<IOWebSocketChannel>> motorWebSocketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25001').obs;
  }

  motorWebSocketDisconnect() async {
    motorChannel.value.sink.close();
  }

  sendFood() async {
    motorWebSocketConnect().then((value) => value.value.sink.add('food'));

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '밥주기'));
  }

  sendWater() async {
    motorWebSocketConnect().then((value) => value.value.sink.add('water'));

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
    videoChannel = IOWebSocketChannel.connect(ip + ':25005').obs;
  }

  videoWebSocketDisconnect() async {
    if (isVideoOn.value) {
      isVideoOn.value = false;
      videoChannel.sink.close();
    }
  }

  videoOn() async {
    videoWebSocketConnect();
    videoChannel.value.sink.add('on');
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
