import 'package:flutter/material.dart';

import 'package:pet/regist_dog/progress_dot.dart';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';
import 'package:pet/regist_dog/gender_regist.dart';

// getx
import 'package:get/get.dart';

// number picker
import 'package:numberpicker/numberpicker.dart';

import 'package:pet/screen/screen_info.dart';

import 'package:get_storage/get_storage.dart';

class AgeRegist extends StatelessWidget {
  final AgeScreenController ageScreenController =
      Get.put(AgeScreenController());

  final InfoScreenController infoScreenController =
      Get.put(InfoScreenController());

  AgeRegist({Key? key, required this.name, required this.isNewDog})
      : super(key: key);

  final String name;
  final bool isNewDog;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '',
        isDrawer: false,
        body: Padding(
            padding: EdgeInsets.all(30),
            child: Obx(() => Column(children: <Widget>[
                  Center(
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 150),
                          child: ProgressDot(progressIndex: 1)),
                      Text(
                        '${name}의 나이를 알려주세요',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xFF049A5B),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: NumberPicker(
                              value: ageScreenController._curAge.value,
                              minValue: 0,
                              maxValue: 20,
                              haptics: true,
                              selectedTextStyle: TextStyle(
                                  color: Color(0xFF049A5B),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              onChanged: (value) =>
                                  ageScreenController._curAge.value = value)),
                      SizedBox(height: 45),
                      Text(
                        ageScreenController._curAge.value.toString() + '살',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  Spacer(),
                  FractionallySizedBox(
                      widthFactor: 0.9,
                      child: ElevatedButton(
                          onPressed: () => Get.defaultDialog(
                              title: '확인',
                              buttonColor: Color(0xFF049A5B),
                              confirmTextColor: Color(0xFFF0F0F0),
                              cancelTextColor: Colors.black,
                              content: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${name}의 나이가 ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: ageScreenController._curAge.value
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '살이 맞나요?',
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              textConfirm: '확인',
                              onConfirm: () {
                                Get.back();
                                if (isNewDog) {
                                  Get.off(GenderRegist(
                                    name: name,
                                    age: ageScreenController._curAge.value,
                                    isNewDog: true,
                                  ));
                                } else {
                                  box.write('dogAge',
                                      ageScreenController._curAge.value);

                                  infoScreenController.getProfileData();

                                  Get.back();
                                }
                              },
                              textCancel: '취소'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF049A5B)),
                          child: Text('완료'))),
                ]))));
  }
}

class AgeScreenController extends GetxController {
  var _curAge = 0.obs;
  var curGender = ''.obs;
}
