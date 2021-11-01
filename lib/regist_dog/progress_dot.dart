import 'package:flutter/material.dart';

class ProgressDot extends StatelessWidget {
  ProgressDot({Key? key, required this.progressIndex}) : super(key: key);

  final int progressIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: progressIndex == 0 ? Color(0xFF049A5B) : Colors.grey,
                  shape: BoxShape.circle),
            )),
        Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: progressIndex == 1 ? Color(0xFF049A5B) : Colors.grey,
                  shape: BoxShape.circle),
            )),
        Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: progressIndex == 2 ? Color(0xFF049A5B) : Colors.grey,
                  shape: BoxShape.circle),
            )),
        Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: progressIndex == 3 ? Color(0xFF049A5B) : Colors.grey,
                  shape: BoxShape.circle),
            )),
        Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: progressIndex == 4 ? Color(0xFF049A5B) : Colors.grey,
                  shape: BoxShape.circle),
            )),
      ],
    );
  }
}
