import 'package:flutter/material.dart';

import 'dart:typed_data';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// getx
import 'package:get/get.dart';

// sqlite
import '../sqlite.dart';

// wave
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

// fl_chart
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  HomeScreen({Key? key}) : super(key: key) {
    homeScreenController.getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '홈',
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VideoArea(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      WavePercent(
                        name: '밥',
                        percent: homeScreenController.loadCellDataFood,
                        sendFunc: homeScreenController.sendFood,
                      ),
                      SizedBox(width: 10),
                      WavePercent(
                        name: '물',
                        percent: homeScreenController.loadCellDataWater,
                        sendFunc: homeScreenController.sendWater,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BallCard(sendFunc: homeScreenController.sendBall),
                  SizedBox(
                    height: 10,
                  ),
                  MoveCheckCard(),
                  SizedBox(
                    height: 10,
                  ),
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
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: FractionallySizedBox(
                widthFactor: 1,
                child: Obx(
                  () => Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: IconButton(
                                onPressed: homeScreenController.videoOn,
                                icon: Icon(Icons.play_arrow),
                                color: Colors.white,
                                iconSize: 72,
                              ))),
                ))));
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
    return Stack(children: <Widget>[
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
                Obx(() => Text((percent.value * 100).toString() + '%',
                    style: TextStyle(
                        color: percent.value >= 0.3
                            ? Colors.black45
                            : Colors.black87,
                        fontSize: 40,
                        fontWeight: FontWeight.bold))),
              ]))
    ]);
  }
}

class BallCard extends StatelessWidget {
  BallCard({Key? key, required this.sendFunc}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final sendFunc;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
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
              child: Obx(() => Row(children: <Widget>[
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
                  ])),
            )));
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
                child: Padding(
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
                    ))),
          ],
        ));
  }
}

class HomeScreenController extends GetxController {
  WebSocketChannel? dataChannel;
  var motorChannel;
  var videoChannel;

  var bottomSheetText = ''.obs;

  var isVideoOn = false.obs;

  var loadCellDataFood = 0.0.obs;
  var loadCellDataWater = 0.0.obs;

  var isBall = true.obs;
  var ballText = '공이 있어요'.obs;

  String ip = 'ws://192.168.1.132';

  var momentDataList = [
    11,
    22,
    31,
    41,
    31,
    21,
    31,
    41,
    31,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    12,
    18,
    29,
    10,
    21,
    22,
    23,
    24,
  ].obs;
  var barChartList = RxList<BarChartGroupData>();

  getChartData() {
    barChartList.clear();

    // barChartDataList에 값 넣기
    this.momentDataList.asMap().forEach((key, value) {
      barChartList.add(BarChartGroupData(x: key - 1, barRods: [
        BarChartRodData(y: value.toDouble(), width: 10, colors: [Colors.white])
      ]));
    });
  }

  @override
  void onInit() {
    super.onInit();
    dataChannel = IOWebSocketChannel.connect(ip + ':25001');
  }

  // 여기는 데이터
  setData(double data) {
    this.loadCellDataFood.value = data;
  }

  dataWebSocketConnect() async {
    this.dataChannel = WebSocketChannel.connect(Uri.parse(ip + ':25001'));

    print('done');
    dataChannel!.sink.add('done');

    dataChannel!.stream.listen((event) {
      setData(double.parse(event));
    });
  }

  // 여기는 모터
  Future<Rx<IOWebSocketChannel>> motorWebSocketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25001').obs;
  }

  loadCellWebSocketDisconnect() async {
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

    isBall.value = false;

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '공던지기'));
  }

  // 여기부터 비디오
  Future<Rx<IOWebSocketChannel>> videoWebSocketConnect() async {
    return IOWebSocketChannel.connect(ip + ':25005').obs;
  }

  videoWebSocketDisconnect() async {
    videoChannel.value.sink.close();
  }

  videoOn() async {
    videoWebSocketConnect().then((channel) {
      videoChannel = channel;
      channel.value.sink.add('on');

      Future.delayed(Duration(seconds: 1))
          .then((value) => isVideoOn.value = true);
    });
  }

  videoOff() async {
    isVideoOn.value = false;

    videoChannel.value.sink.add('off');
    videoWebSocketDisconnect();
  }
}
