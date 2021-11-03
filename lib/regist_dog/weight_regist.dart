import 'package:flutter/material.dart';

import 'package:pet/regist_dog/progress_dot.dart';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';
import 'package:pet/regist_dog/profile_image_regist.dart';

// getx
import 'package:get/get.dart';

// number picker
import 'package:numberpicker/numberpicker.dart';

class WeightRegist extends StatelessWidget {
  final WeightScreenController weightScreenController =
      Get.put(WeightScreenController());

  WeightRegist(
      {Key? key, required this.name, required this.age, required this.gender})
      : super(key: key);

  final String name;
  final int age;
  final String gender;

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '',
        isDrawer: false,
        body: Obx(() => Padding(
            padding: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 110),
                  child: ProgressDot(progressIndex: 3)),
              Text(
                '${name}의 몸무게를 알려주세요',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xFF049A5B),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: NumberPicker(
                        value: weightScreenController._curWeight_1.value,
                        minValue: 0,
                        maxValue: 99,
                        haptics: true,
                        selectedTextStyle: TextStyle(
                            color: Color(0xFF049A5B),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          weightScreenController._curWeight_1.value = value;
                          weightScreenController.combineWeight();
                        })),
                SizedBox(
                  width: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xFF049A5B),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: NumberPicker(
                        value: weightScreenController._curWeight_2.value,
                        minValue: 0,
                        maxValue: 9,
                        haptics: true,
                        selectedTextStyle: TextStyle(
                            color: Color(0xFF049A5B),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          weightScreenController._curWeight_2.value = value;
                          weightScreenController.combineWeight();
                        }))
              ]),
              Padding(
                  padding: EdgeInsets.all(65),
                  child: Text(
                    weightScreenController._curWeight.value.toString() + ' kg',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Spacer(),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                      onPressed: () => weightScreenController._curWeight == 0.0
                          ? Get.defaultDialog(
                              title: '오잉?', content: Text('강아지가 너무 가벼워요'))
                          : Get.defaultDialog(
                              title: '확인',
                              buttonColor: Color(0xFF049A5B),
                              confirmTextColor: Color(0xFFF0F0F0),
                              cancelTextColor: Colors.black,
                              content: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${name}의 몸무게가 ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: weightScreenController
                                        ._curWeight.value
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: 'kg이 맞나요?',
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              textConfirm: '확인',
                              onConfirm: () {
                                Get.back();
                                Get.off(ProfileImageRegist(
                                    name: name,
                                    age: age,
                                    gender: gender,
                                    weight: weightScreenController
                                        ._curWeight.value));
                              },
                              textCancel: '취소'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF049A5B)),
                      child: Text('완료'))),
            ]))));
  }
}

class WeightScreenController extends GetxController {
  var _curWeight_1 = 0.obs;
  var _curWeight_2 = 0.obs;

  var _curWeight = 0.0.obs;

  combineWeight() {
    _curWeight.value =
        double.parse('${_curWeight_1.value}.${_curWeight_2.value}');
  }
}
