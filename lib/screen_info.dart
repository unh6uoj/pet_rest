import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('내 정보'),
            backgroundColor: Colors.green[500],
            leading: Icon(Icons.menu)),
        body: Column(children: <Widget>[]));
  }
}
