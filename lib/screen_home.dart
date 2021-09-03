import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(child: Image(image: AssetImage('images/pet_food.png'))),
            Expanded(child: Image(image: AssetImage('images/pet_water.png')))
          ]),
          Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        percent: 0.9,
                        center: Text("50.0%"),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.greenAccent))),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        percent: 0.9,
                        center: Text("90.0%"),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.greenAccent)))
          ]),
          Row(children: <Widget>[
            // percentage bar
            Text("percentage bar")
          ]),
          Row(children: <Widget>[
            // Buttons
            Text("Buttons")
          ]),
          Row(children: <Widget>[
            // move graph
            Text("move graph")
          ]),
          Row(children: <Widget>[
            // ball Button
            Text("ball button")
          ])
        ]);
  }
}
