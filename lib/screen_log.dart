import 'package:flutter/material.dart';

// Calendar
import 'package:table_calendar/table_calendar.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      ),
      Expanded(
          child: ListView(children: [
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
        Container(color: Colors.black12, width: 400, height: 200),
      ])),
    ]));
  }
}
