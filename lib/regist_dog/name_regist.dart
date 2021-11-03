import 'package:flutter/material.dart';

import 'package:pet/regist_dog/progress_dot.dart';
//화면
import 'package:pet/regist_dog/age_regist.dart';
// 페이지 공통
import 'package:pet/screen/scaffold.dart';

// getx
import 'package:get/get.dart';

class NameRegist extends StatelessWidget {
  NameRegist({Key? key}) : super(key: key);

  final nameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '',
        isDrawer: false,
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Center(
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 100),
                      child: ProgressDot(progressIndex: 0)),
                  Text(
                    '강아지 이름을 알려주세요',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: nameInputController,
                    textAlign: TextAlign.center,
                    cursorColor: Color(0xFF049A5B),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        focusColor: Color(0xFF049A5B),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF049A5B), width: 2))),
                    style: TextStyle(fontSize: 20),
                  )
                ]),
              ),
              Spacer(),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                      onPressed: () => nameInputController.text == ''
                          ? Get.defaultDialog(
                              title: '오잉?!', content: Text('이름을 입력 해주세요'))
                          : Get.defaultDialog(
                              title: '확인',
                              buttonColor: Color(0xFF049A5B),
                              confirmTextColor: Color(0xFFF0F0F0),
                              cancelTextColor: Colors.black,
                              content: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: '강아지 이름이 ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: '${nameInputController.text}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '이(가) 맞나요?',
                                    style: TextStyle(color: Colors.black)),
                              ])),
                              textConfirm: '확인',
                              onConfirm: () {
                                Get.back();
                                Get.off(
                                    AgeRegist(name: nameInputController.text));
                              },
                              textCancel: '취소'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF049A5B)),
                      child: Text('완료'))),
            ],
          ),
        ));
  }
}
