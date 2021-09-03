import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
          Row(children: <Widget>[
            // 사료, 물 잔량
            Expanded(child: PercentBar(isLinear: true, data: 0.9)),
            Expanded(child: PercentBar(isLinear: true, data: 0.8))
          ]),

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
  final double data;
  _PercentBarState(this.isLinear, this.data);

  @override
  Widget build(BuildContext context) {
    // 최대 칼로리
    const double maxCalorie = 100;

    // 선형/비선형 퍼센트 바 반환
    return this.isLinear

        // 선형 퍼센트 바
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            padding: EdgeInsets.all(5.0),
            child: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: this.data,
                center: Text((this.data * 100).toString() + "%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.lightGreen[300]))

        // 비선형(원형) 퍼센트 바
        : Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            padding: EdgeInsets.all(5.0),
            child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: (this.data * 100) / maxCalorie,
                center: new Text(this.data.toString() + "cal",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0)),
                footer: new Text("강아지 운동량",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0)),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.lightGreen[300]));
  }
}
