import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:pet/websocket_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final WebSocketController webSocketController =
      Get.put(WebSocketController());

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF049A5B),
          title: Text('설정'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                onSubmitted: (value) async {
                  await box.write('ip', value);
                  Get.snackbar('IP를 변경했어요', value);
                  webSocketController.setIp();
                },
                decoration: InputDecoration(
                    labelText: 'IP 변경하기',
                    labelStyle: TextStyle(color: Color(0xFF505050)),
                    hintText: '192.168.1.40'),
              )
            ],
          ),
        ));
  }
}
