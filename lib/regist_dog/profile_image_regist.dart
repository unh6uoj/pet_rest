import 'package:flutter/material.dart';
import 'dart:io';

import 'package:pet/regist_dog/progress_dot.dart';
// 페이지 공통
import 'package:pet/screen/scaffold.dart';

// getx
import 'package:get/get.dart';

// image_picker
import 'package:image_picker/image_picker.dart';

class ProfileImageRegist extends StatelessWidget {
  final ProfileImageScreenController profileImageScreenController =
      Get.put(ProfileImageScreenController());

  ProfileImageRegist(
      {Key? key,
      required this.name,
      required this.age,
      required this.gender,
      required this.weight})
      : super(key: key);

  final String name;
  final int age;
  final String gender;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '',
        isDrawer: false,
        body: Obx(() => Padding(
            padding: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: ProgressDot(progressIndex: 4)),
              Text(
                '${name}의 사진을 등록 해보세요',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                      onTap: profileImageScreenController.getProfileImage,
                      customBorder: CircleBorder(),
                      child: Container(
                        width: 135,
                        height: 135,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: profileImageScreenController.isImage.value
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(profileImageScreenController
                                      .profileImage.value.path),
                                  fit: BoxFit.fill,
                                ))
                            : null,
                      ))),
              FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                      onPressed: () => Get.defaultDialog(
                          title: '확인',
                          buttonColor: Color(0xFF049A5B),
                          confirmTextColor: Color(0xFFF0F0F0),
                          cancelTextColor: Colors.black,
                          content: Text('${name}의 정보를 등록할게요'),
                          textConfirm: '확인',
                          onConfirm: () {
                            Get.back();
                            // Get.to(ProfileImageRegist(
                            //     name: name,
                            //     age: profileImageScreenController
                            //         ._curWeight.value));
                          },
                          textCancel: '취소'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF049A5B)),
                      child: Text('완료'))),
            ]))));
  }
}

class ProfileImageScreenController extends GetxController {
  var isImage = false.obs;
  var isDoggie = false.obs;

  var profileImage = XFile('images/peterest_logo.png').obs;

  getProfileImage() async {
    profileImage.value =
        await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;

    isImage.value = true;
  }
}