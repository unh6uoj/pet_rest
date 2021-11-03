import 'package:flutter/material.dart';

import 'package:pet/regist_dog/progress_dot.dart';

// 페이지 공통
import 'package:pet/screen/scaffold.dart';
import 'package:pet/regist_dog/weight_regist.dart';

// getx
import 'package:get/get.dart';

class GenderRegist extends StatelessWidget {
  final GenderScreenController genderScreenController =
      Get.put(GenderScreenController());

  GenderRegist({Key? key, required this.name, required this.age})
      : super(key: key);

  final name;
  final age;

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '',
        isDrawer: false,
        body: Obx(() => Padding(
            padding: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              Center(
                  child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 150),
                    child: ProgressDot(progressIndex: 2)),
                Text(
                  '${name}의 성별을 알려주세요',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  InkWell(
                      customBorder: CircleBorder(),
                      onTap: () =>
                          genderScreenController._curGender.value = '수컷',
                      child: AnimatedContainer(
                          width: 100,
                          height: 100,
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: genderScreenController._curGender.value ==
                                      '수컷'
                                  ? Color(0xFF049A5B)
                                  : Color(0xFFF0F0F0),
                              // borderRadius: BorderRadius.all(
                              //     Radius.circular(15)),
                              border: Border.all(
                                  width: 2, color: Color(0xFF049A5B))),
                          child: Icon(
                            Icons.male,
                            color:
                                genderScreenController._curGender.value == '수컷'
                                    ? Color(0xFFF0F0F0)
                                    : Colors.black,
                            size: 50,
                          ))),
                  SizedBox(
                    width: 50,
                  ),
                  InkWell(
                      customBorder: CircleBorder(),
                      onTap: () =>
                          genderScreenController._curGender.value = '암컷',
                      child: AnimatedContainer(
                          width: 100,
                          height: 100,
                          duration: const Duration(milliseconds: 300),
                          foregroundDecoration:
                              BoxDecoration(shape: BoxShape.circle),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: genderScreenController._curGender.value ==
                                      '암컷'
                                  ? Color(0xFF049A5B)
                                  : Color(0xFFF0F0F0),
                              // borderRadius: BorderRadius.all(
                              //     Radius.circular(15)),
                              border: Border.all(
                                  width: 2, color: Color(0xFF049A5B))),
                          child: Icon(
                            Icons.female,
                            color:
                                genderScreenController._curGender.value == '암컷'
                                    ? Color(0xFFF0F0F0)
                                    : Colors.black,
                            size: 50,
                          ))),
                ])
              ])),
              Spacer(),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                      onPressed: () => genderScreenController._curGender == ''
                          ? Get.defaultDialog(
                              title: '앗!', content: Text('성별을 선택 해주세요'))
                          : Get.defaultDialog(
                              title: '확인',
                              buttonColor: Color(0xFF049A5B),
                              confirmTextColor: Color(0xFFF0F0F0),
                              cancelTextColor: Colors.black,
                              content: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '${name}의 성별이 ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text:
                                        genderScreenController._curGender.value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '이 맞나요?',
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              textConfirm: '확인',
                              onConfirm: () {
                                Get.back();
                                Get.to(WeightRegist(
                                    name: name,
                                    age: age,
                                    gender: genderScreenController
                                        ._curGender.value));
                              },
                              textCancel: '취소'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF049A5B)),
                      child: Text('완료'))),
            ]))));
  }
}

class GenderScreenController extends GetxController {
  var _curGender = ''.obs;
}
