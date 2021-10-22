import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet/drawer.dart';

import 'route_setting.dart';

// getx
import 'package:get/get.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('내 정보'), backgroundColor: Colors.green[500]),
        drawer: myDrawer,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SettingButton(),
        ])));
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: InkWell(
        onTap: () => Get.to(SettingScreen()),
        child: Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey, width: 0.5))),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20),
                Expanded(
                    flex: 3,
                    child: Text(
                      '설정',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20),
                    )),
                Expanded(child: Icon(Icons.arrow_forward_ios))
              ],
            )),
      ),
    );
  }
}
