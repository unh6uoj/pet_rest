import 'package:flutter/material.dart';

import 'dart:typed_data';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';

// websocket
import 'package:pet/websocket_controller.dart';

// getx
import 'package:get/get.dart';

// wave
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

// fl_chart
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

  HomeScreen({Key? key}) : super(key: key) {
    webSocketController.setIp();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 전환 시 stream 구독 에러 방지를 위해 초기화
    webSocketController.isVideoOn.value = false;
    webSocketController.dataOn();
    homeScreenController.getChartData();

    return MyPage(
        title: '홈',
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      VideoArea(),
                      webSocketController.isData.value
                          ?
                          // ? StreamBuilder(
                          //     stream: webSocketController.dataChannel.stream,
                          //     builder: (context, snapshot) {
                          //       if (snapshot.hasData) {
                          //         homeScreenController.setData(snapshot.data);
                          //       }
                          Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    WavePercent(
                                      name: '밥',
                                      percent:
                                          webSocketController.loadCellDataFood,
                                      sendFunc: webSocketController.sendFood,
                                    ),
                                    SizedBox(width: 10),
                                    WavePercent(
                                      name: '물',
                                      percent:
                                          webSocketController.loadCellDataWater,
                                      sendFunc: webSocketController.sendWater,
                                    ),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              BallCard(sendFunc: webSocketController.sendBall),
                              SizedBox(
                                height: 10,
                              ),
                              MoveCheckCard(),
                              SizedBox(
                                height: 10,
                              ),
                            ])
                          : SizedBox(),
                    ]))));
  }
}

class VideoArea extends StatelessWidget {
  VideoArea({Key? key}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

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
                  child: webSocketController.isVideoOn.value
                      ? InkWell(
                          onTap: () => webSocketController.videoOff(),
                          child: StreamBuilder(
                              stream: webSocketController.videoChannel.stream,
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
                                                  webSocketController.videoOn,
                                              icon:
                                                  Icon(Icons.replay, size: 35),
                                              color: Colors.white,
                                            ),
                                          ]);
                              }))
                      : IconButton(
                          onPressed: webSocketController.videoOn,
                          icon: Icon(Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 72,
                        ))),
            )));
  }
}

class BottomSheetForSendData extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

  BottomSheetForSendData({Key? key, required this.name, required this.sendFunc})
      : super(key: key);

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
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

  WavePercent({Key? key, required this.name, this.percent, this.sendFunc})
      : super(key: key);

  final name;
  final percent;
  final sendFunc;

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
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 180),
                    Text(
                      (percent.value * 100).toStringAsFixed(1) + '%',
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

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

  final sendFunc;

  @override
  Widget build(BuildContext context) {
    return Obx(() => FractionallySizedBox(
        widthFactor: 0.95,
        child: InkWell(
            onTap: () {
              homeScreenController.bottomSheetText.value =
                  '여기를 누르면 공을 날릴 수 있어요';

              webSocketController.isBall.value
                  ? Get.bottomSheet(
                      BottomSheetForSendData(name: '공', sendFunc: sendFunc))
                  : Get.snackbar('공이 없어요', 'pet station에 공을 넣어주세요',
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.black,
                      backgroundColor: Color(0xFF758f2));
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
                    child: webSocketController.isBall.value
                        ? Image.asset('images/ball_on.png')
                        : Image.asset('images/ball_off.png')),
                webSocketController.isBall.value
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
  var ballText = '공이 없어요'.obs;
  var bottomSheetText = ''.obs;

  var momentDataList = [].obs;
  var barChartList = RxList<BarChartGroupData>();

  WebSocketController webSocketController = Get.put(WebSocketController());

  getChartData() {
    List<BarChartGroupData> tempList = [];

    momentDataList = RxList([
      '3.4',
      '2.2',
      '4.3',
      '1.1',
      '4.9',
      '6.3',
      '5.5',
      '4.4',
      '0.0',
      '4.4',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '0.0',
      '1.8',
      '0.5',
      '1.2',
      '4.4'
    ]);
    // barChartDataList에 값 넣기
    momentDataList.asMap().forEach((key, value) {
      tempList.add(BarChartGroupData(x: key - 1, barRods: [
        BarChartRodData(
            y: (double.parse(value) * 5.5).roundToDouble(),
            width: 10,
            colors: [Colors.white])
      ]));
    });

    barChartList.value = tempList;
  }

  zeroToOneData(data) {
    if (data > 1) {
      return 1.0;
    } else if (data < 0) {
      return 0.0;
    } else {
      return data;
    }
  }

  setData(receivedData) {
    // 데이터 전처리
    List<dynamic> sensorData = receivedData.toString().split('[')[0].split(',');
    List<dynamic> cameraData =
        (receivedData.toString().split('[')[1]).replaceAll(']', '').split(',');

    double foodData = double.parse(sensorData[0]);
    double waterData = double.parse(sensorData[1]);

    webSocketController.loadCellDataFood.value = zeroToOneData(foodData);
    webSocketController.loadCellDataWater.value = zeroToOneData(waterData);
    webSocketController.isBall.value = sensorData[2] == 'True';

    momentDataList.value = cameraData;

    getChartData();
  }
}
