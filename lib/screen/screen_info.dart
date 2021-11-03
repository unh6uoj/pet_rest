import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

// screen
import 'route_setting.dart';
import 'route_app_info.dart';
import 'package:pet/screen/scaffold.dart';
import 'package:pet/regist_dog/name_regist.dart';

// getx
import 'package:get/get.dart';

// image_picker
import 'package:image_picker/image_picker.dart';

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
              color: Color(0xFF17D282),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: infoScreenController.isDoggie.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // 강아지 프로필 사진
                      Obx(() => Container(
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
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            infoScreenController.dogName.value,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            infoScreenController.dogAge.value.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            infoScreenController.dogGender.value,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            infoScreenController.dogWeight.value.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  )
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
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF049A5B)),
                            child: Text('강아지 등록하러 가기'))
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

class InfoScreenController extends GetxController {
  var isImage = false.obs;

  var profileImage = XFile('images/peterest_logo.png').obs;

  var isDoggie = false.obs;
  var dogName = ''.obs;
  var dogAge = 0.obs;
  var dogGender = ''.obs;
  var dogWeight = 0.0.obs;

  final box = GetStorage();

  getProfileImage() async {
    profileImage.value =
        await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;

    isImage.value = true;
  }

  getProfileData() async {
    this.isDoggie.value = await box.read('isDoggie');
    this.dogName.value = await box.read('dogName');
    this.dogAge.value = await box.read('dogAge');
    this.dogGender.value = await box.read('dogGender');
    this.dogWeight.value = await box.read('dogWeight');
    this.profileImage.value = await box.read('dogProfile');
  }
}
