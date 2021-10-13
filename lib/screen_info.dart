import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('정보'),
            backgroundColor: Colors.green[500],
            leading: Icon(Icons.menu)),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(onPressed: () {}, child: Text('앱 설정'))
              ]),
        )));
  }
}
