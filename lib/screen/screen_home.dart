import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet/main.dart';

import 'dart:typed_data';

// drawer
import 'package:pet/drawer.dart';

// WebScoket
import 'package:web_socket_channel/io.dart';

// getx
import 'package:get/get.dart';

// sqlite
import '../sqlite.dart';

// wave
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        appBar: AppBar(title: Text('홈'), backgroundColor: Color(0xff00AAA1)),
        drawer: myDrawer,
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
                      // HomeDataCard(
                      //   name: '밥',
                      //   isLinear: true,
                      //   sendFunc: homeScreenController.sendFood,
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // HomeDataCard(
                      //   name: '물',
                      //   isLinear: true,
                      //   sendFunc: homeScreenController.sendWater,
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BallCard(sendFunc: homeScreenController.sendBall)
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

// class HomeDataCard extends StatelessWidget {
//   HomeDataCard(
//       {Key? key,
//       required this.name,
//       required this.isLinear,
//       required this.sendFunc})
//       : super(key: key);

//   final String name;
//   final bool isLinear;
//   final sendFunc;

//   final HomeScreenController homeScreenController =
//       Get.put(HomeScreenController());

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: 5),
//         child: InkWell(
//             onTap: () {
//               homeScreenController.bottomSheetText.value =
//                   '여기를 누르면 $name을 줄 수 있어요';
//               Get.bottomSheet(
//                   BottomSheetForSendData(name: name, sendFunc: sendFunc));
//             },
//             child: Container(
//                 width: 180,
//                 height: 250,
//                 decoration: BoxDecoration(
//                     color: Color(0xffF9FFFC),
//                     borderRadius: BorderRadius.all(Radius.circular(15)),
//                     boxShadow: [
//                       BoxShadow(
//                           spreadRadius: 0.5,
//                           blurRadius: 0.5,
//                           offset: Offset(0, 3),
//                           color: Colors.grey.withOpacity(0.4))
//                     ]),
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           name,
//                           textScaleFactor: 1.3,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     Obx(() => Text(
//                         (homeScreenController.loadCellDataFood.value * 100)
//                                 .toString() +
//                             '%',
//                         style: TextStyle(
//                             fontSize: 26, fontWeight: FontWeight.bold))),
//                   ],
//                 ))));
//   }
// }

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
              borderRadius: BorderRadius.all(Radius.circular(15))),
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
                          0.89 - percent.value
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
                waveAmplitude: 0,
                size: Size(182, 250),
              ))),
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

// 퍼센트 바
// class PercentBar extends StatefulWidget {
//   const PercentBar({Key? key, this.isLinear = true}) : super(key: key);

//   final bool? isLinear;

//   @override
//   _PercentBarState createState() => _PercentBarState(this.isLinear as bool);
// }

// class _PercentBarState extends State<PercentBar> {
//   // 데이터 전달받기
//   final bool isLinear;

//   _PercentBarState(this.isLinear);

//   final HomeScreenController homeScreenController =
//       Get.put(HomeScreenController());

//   @override
//   Widget build(BuildContext context) {
//     // 최대 칼로리
//     const double maxCalorie = 100;
//     var foodData = homeScreenController.loadCellDataFood.value;
//     // 선형/비선형 퍼센트 바 반환
//     return this.isLinear
//         // 선형 퍼센트 바
//         ? Container(
//             margin: EdgeInsets.symmetric(horizontal: 15.0),
//             padding: EdgeInsets.all(5.0),
//             child: LinearPercentIndicator(
//               animation: true,
//               animateFromLastPercent: true, // 이전 퍼센트에서 애니메이션 재생
//               animationDuration: 1000,
//               lineHeight: 5.0,
//               percent: foodData,
//               // center: Text((foodData * 100).toStringAsFixed(1).toString()),
//               linearStrokeCap: LinearStrokeCap.roundAll,
//               // progressColor: Colors.lightGreen[500]
//               linearGradient: LinearGradient(
//                   begin: const FractionalOffset(0.0, 0.0),
//                   end: const FractionalOffset(1.0, 1.0),
//                   colors: <Color>[
//                     const Color(0xff72ed59),
//                     const Color(0xff6ac65f),
//                     const Color(0xff64a060),
//                     const Color(0xff5d7b5d),
//                     const Color(0xff565756),
//                   ]),
//             ))

//         // 비선형(원형) 퍼센트 바
//         : Container(
//             margin: EdgeInsets.symmetric(vertical: 15.0),
//             padding: EdgeInsets.all(5.0),
//             child: CircularPercentIndicator(
//                 animation: true,
//                 animateFromLastPercent: true, // 이전 퍼센트에서 애니메이션 재생
//                 animationDuration: 1000,
//                 radius: 100.0,
//                 lineWidth: 12.0,
//                 backgroundColor: Colors.white70,
//                 percent: foodData,
//                 center: new Text((foodData * 100).toString() + '%',
//                     style: new TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20.0)),
//                 circularStrokeCap: CircularStrokeCap.round,
//                 progressColor: Colors.lightGreen[700]));
//   }
// }

class BallCard extends StatelessWidget {
  BallCard({Key? key, required this.sendFunc}) : super(key: key);

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  var sendFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          homeScreenController.bottomSheetText.value = '공 날리기';
          Get.bottomSheet(
              BottomSheetForSendData(name: '공', sendFunc: sendFunc));
        },
        child: Container(
          width: 374,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Obx(() => Row(children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(45),
                    child: homeScreenController.isBall.value
                        ? Image.asset('images/ball_on.png')
                        : Image.asset('images/ball_off.png')),
                homeScreenController.isBall.value
                    ? Text('공이 있어요')
                    : Text('공이 없어요'),
              ])),
        ));
  }
}

class HomeScreenController extends GetxController {
  var motorChannel;
  var videoChannel;
  var bottomSheetText = ''.obs;

  var isVideoOn = false.obs;

  var loadCellDataFood = 0.85.obs;
  var loadCellDataWater = 0.5.obs;

  var isBall = true.obs;
  var ballText = '공이 있어요'.obs;

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

    isBall.value = false;

    DBHelper().createData(
        History(date: DBHelper().getCurDateTime(), activity: '공던지기'));
  }
}
