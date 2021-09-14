import 'package:flutter/material.dart';
import 'package:pet/main.dart';

// persent_indicator
import 'package:percent_indicator/percent_indicator.dart';

// Provider
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 요소들을 세로로 나란히 배치하기 위한 레이아웃
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        // 요소들 생성
        children: <Widget>[
          // 첫번째 가로줄
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 사료, 물 이미지
                Image(image: AssetImage('images/pet_food.png'), width: 150),
                Image(image: AssetImage('images/pet_water.png'), width: 150)
              ]),

          // 두번째 가로줄
          Row2(),

          // 세번째 가로줄
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // 사료, 물 급여 버튼
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {},
                    child: Text('밥주기!')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {},
                    child: Text('물주기!'))
              ]),

          // 중간 여백
          Container(height: 30),

          // 네번째 가로줄
          Row(children: <Widget>[
            // 운동량
            Expanded(child: PercentBar(isLinear: false, data: 0.7))
          ]),

          // 다섯번째 가로줄
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // 공 던지기 버튼
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {},
                    child: Text('공 던지기!'))
              ])
        ]);
  }
}

// 일단 이름 이렇게 해놓음
// 추후에 수정 요함
class Row2 extends StatefulWidget {
  const Row2({Key? key}) : super(key: key);

  @override
  _Row2State createState() => _Row2State();
}

class _Row2State extends State<Row2> {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      // 사료, 물 잔량
      context.watch<LoadCellWebScoket>().isLoadCellConnect
          ? StreamBuilder(
              stream: context.read<LoadCellWebScoket>().channel.stream,
              builder: (context, snapshot) {
                context.read<LoadCellWebScoket>().loadCellDataFood =
                    double.parse(snapshot.data as String);
                return Expanded(
                    //child: Text(snapshot.data as String));
                    child: PercentBar(
                        isLinear: true,
                        data: double.parse(snapshot.data as String)));
              },
            )
          : Expanded(child: PercentBar(isLinear: true, data: 0.8)),
      Expanded(child: PercentBar(isLinear: true, data: 0.8))
    ]);
  }
}

// 퍼센트 바
class PercentBar extends StatefulWidget {
  const PercentBar({Key? key, this.isLinear, @required this.data})
      : super(key: key);

  final bool? isLinear;
  final double? data;

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
    double foodData = context.watch<LoadCellWebScoket>().loadCellDataFood;
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
                center:
                    Text((foodData * 100).toStringAsFixed(1).toString() + "%"),
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
                radius: 120.0,
                lineWidth: 15.0,
                percent: (this.data * 100) / maxCalorie,
                center: new Text(this.data.toString() + "cal",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                footer: new Text("강아지 운동량",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0)),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.lightGreen[500]));
  }
}
