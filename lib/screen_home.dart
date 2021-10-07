import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pet/main.dart';

// persent_indicator
import 'package:percent_indicator/percent_indicator.dart';

// Provider
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      )),
                      Expanded(
                          child: HomeDataCard(
                        name: '물',
                        isLinear: false,
                      )),
                    ],
                  ),
                  HomeDataCard(
                    name: '공',
                    isLinear: false,
                  )
                ])));
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
        height: 340,
        // watch() 함수를 통해 데이터 접근
        // watch()는 UI를 바로 업데이트 함
        child: Container(
            child: StreamBuilder(
          // read() 함수를 통해 데이터 접근
          // read()는 UI업데이트 하지 않음. 여기선 stream으로 값을 받아오기 때문에
          // UI업데이트는 자동으로 된다.
          stream: context.read<HomeProvider>().videoChannel.stream,
          builder: (context, snapshot) {
            return snapshot.hasData && context.watch<HomeProvider>().isVideoOn
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: FractionallySizedBox(
                        child: ElevatedButton(
                            onPressed: context.watch<HomeProvider>().videoOff,
                            // color: Colors.black,
                            child: Image.memory(
                              snapshot.data as Uint8List,
                              gaplessPlayback:
                                  true, // gaplessPlayback을 true로 하지 않으면 이미지 변경 될 때 마다 깜빡깜빡 한다.
                            ))))
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                            color: Colors.black,
                            child: IconButton(
                              onPressed: context.watch<HomeProvider>().videoOn,
                              icon: Icon(Icons.play_arrow),
                              iconSize: 75,
                              color: Colors.white,
                            ))));
          },
        )));
  }
}

class HomeDataCard extends StatelessWidget {
  const HomeDataCard({Key? key, this.name, this.isLinear}) : super(key: key);

  final String? name;
  final bool? isLinear;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.green[400],
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      this.name as String,
                      textScaleFactor: 1.3,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    PercentBar(isLinear: this.isLinear, data: 0.5),
                    if (this.name == '밥')
                      ElevatedButton(
                        onPressed: context.read<HomeProvider>().sendFood,
                        child: Text(this.name as String,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                        ),
                      )
                    else if (this.name == '물')
                      ElevatedButton(
                          onPressed: context.read<HomeProvider>().sendWater,
                          child: Text(this.name as String,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                          ))
                    else
                      ElevatedButton(
                          onPressed: context.read<HomeProvider>().sendBall,
                          child: Text(this.name as String,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[200],
                          ))
                  ],
                ))));
  }
}

// 퍼센트 바
class PercentBar extends StatefulWidget {
  const PercentBar({Key? key, this.isLinear = true, @required this.data})
      : super(key: key);

  final bool? isLinear;
  final double? data; // data 변수 지금 상태에선 사용 x

  @override
  _PercentBarState createState() =>
      _PercentBarState(this.isLinear as bool, this.data as double);
}

class _PercentBarState extends State<PercentBar> {
  // 데이터 전달받기
  final bool isLinear;
  double data;

  _PercentBarState(this.isLinear, this.data);

  @override
  Widget build(BuildContext context) {
    // 최대 칼로리
    const double maxCalorie = 100;
    double foodData = context.watch<HomeProvider>().loadCellDataFood;
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
                percent: (this.data * 100) / maxCalorie,
                center: new Text(this.data.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.lightGreen[700]));
  }
}
