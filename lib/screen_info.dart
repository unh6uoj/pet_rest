import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet/drawer.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('내 정보'), backgroundColor: Colors.green[500]),
        drawer: myDrawer,
        body: Column(children: <Widget>[]));
  }
}
