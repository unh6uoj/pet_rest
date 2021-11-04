import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';

// screen
import 'package:pet/screen/route_setting.dart';
import 'package:pet/screen/route_notice.dart';
import 'package:pet/screen/route_dog_init.dart';
import 'package:pet/screen/scaffold.dart';
import 'package:pet/regist_dog/name_regist.dart';

// getx
import 'package:get/get.dart';

// get_storage
import 'package:get_storage/get_storage.dart';

class InfoScreen extends StatelessWidget {
  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

  InfoScreen({Key? key}) : super(key: key) {
    infoScreenController.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '정보',
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(children: <Widget>[
              DogInfoArea(),
              SizedBox(height: 35),
              ButtonForInfoScreen(name: '공지사항', screen: NoticeScreen()),
              ButtonForInfoScreen(name: '강아지 정보 초기화', screen: DogInitScreen()),
              ButtonForInfoScreen(name: '설정', screen: SettingScreen()),
            ]),
            Container(
                margin: EdgeInsets.only(top: 230), child: DogInfoTextArea())
          ]),
        ));
  }
}

class DogInfoArea extends StatelessWidget {
  DogInfoArea({Key? key}) : super(key: key);

  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
          color: Color(0xFF17D282),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 1,
                color: Colors.grey,
                offset: Offset(0, 1))
          ]),
      child: infoScreenController.isDoggie.value
          ? Obx(() => Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  // 강아지 프로필 사진
                  Container(
                      width: 135,
                      height: 135,
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(infoScreenController.profileImage.value),
                            fit: BoxFit.fill,
                          ))),
                  Text(
                    infoScreenController.dogName.value,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Text(
                    '강아지 정보를 등록 해보세요',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => Get.to(NameRegist()),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF049A5B)),
                      child: Text('강아지 등록하러 가기'))
                ]),
    );
  }
}

class ButtonForInfoScreen extends StatelessWidget {
  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

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

class DogInfoTextArea extends StatelessWidget {
  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

  DogInfoTextArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, 1))
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                infoScreenController.dogAge.value.toString() + '살',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ))),
          Container(width: 1, height: 50, color: Colors.grey),
          Expanded(
              child: Container(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                infoScreenController.dogGender.value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ))),
          Container(width: 1, height: 50, color: Colors.grey),
          Expanded(
              child: Container(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                infoScreenController.dogWeight.value.toString() + 'kg',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ))),
        ],
      ),
    );
  }
}

class InfoScreenController extends GetxController {
  var isImage = false.obs;

  var profileImage = ''.obs;

  var isDoggie = false.obs;
  var dogName = ''.obs;
  var dogAge = 0.obs;
  var dogGender = ''.obs;
  var dogWeight = 0.0.obs;

  final box = GetStorage();

  getProfileData() async {
    isDoggie.value = await box.read('isDoggie');
    dogName.value = await box.read('dogName');
    dogAge.value = await box.read('dogAge');
    dogGender.value = await box.read('dogGender');
    dogWeight.value = await box.read('dogWeight');
    profileImage.value = await box.read('dogProfile');
  }
}
