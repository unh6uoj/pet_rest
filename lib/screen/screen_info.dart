import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

// screen
import 'route_setting.dart';
import 'route_app_info.dart';
import 'package:pet/drawer.dart';

// getx
import 'package:get/get.dart';

// image_picker
import 'package:image_picker/image_picker.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        appBar: AppBar(title: Text('정보'), backgroundColor: Color(0xFF049A5B)),
        drawer: myDrawer,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          DogInfo(),
          ButtonForInfoScreen(name: '설정', screen: SettingScreen()),
          ButtonForInfoScreen(name: '공지사항', screen: AppInfoScreen()),
          ButtonForInfoScreen(name: '앱 정보', screen: AppInfoScreen()),
        ])));
  }
}

class DogInfo extends StatelessWidget {
  DogInfo({Key? key}) : super(key: key);

  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 1,
        child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // 강아지 프로필 사진
                Obx(() => InkWell(
                    onTap: infoScreenController.getProfileImage,
                    child: Container(
                      width: 135,
                      height: 135,
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: infoScreenController.isImage.value
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(infoScreenController
                                    .profileImage.value.path),
                                fit: BoxFit.fill,
                              ))
                          : null,
                    ))),
                SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '강아지 이름',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '강아지 나이',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '강아지 성별',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '강아지 몸무게',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              ],
            )));
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

class InfoScreenController extends GetxController {
  var isImage = false.obs;
  var profileImage = XFile('images/peterest_logo.png').obs;

  getProfileImage() async {
    profileImage.value =
        await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;

    isImage.value = true;
  }
}
