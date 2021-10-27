import 'package:flutter/material.dart';
import 'package:pet/drawer.dart';

// screen
import 'route_setting.dart';
import 'route_app_info.dart';

// getx
import 'package:get/get.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        appBar: AppBar(title: Text('홈'), backgroundColor: Color(0xff00AAA1)),
        drawer: myDrawer,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          ButtonForInfoScreen(name: '설정', screen: SettingScreen()),
          ButtonForInfoScreen(name: '공지사항', screen: AppInfoScreen()),
          ButtonForInfoScreen(name: '앱 정보', screen: AppInfoScreen()),
        ])));
  }
}

class ButtonForInfoScreen extends StatelessWidget {
  ButtonForInfoScreen({Key? key, required this.name, required this.screen})
      : super(key: key);

  final String name;
  final StatelessWidget screen;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: InkWell(
        onTap: () => Get.to(screen),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20),
                Expanded(
                    flex: 3,
                    child: Text(
                      name,
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
