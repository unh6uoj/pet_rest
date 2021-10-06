import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[100],
        ),
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[200],
        ),
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[300],
        ),
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[400],
        ),
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[500],
        ),
        Container(
          width: 400,
          height: 300,
          color: Colors.blueGrey[600],
        ),
      ],
    )));
  }
}
