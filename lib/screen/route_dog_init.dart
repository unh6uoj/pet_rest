import 'package:flutter/material.dart';
import 'package:pet/screen/scaffold.dart';

class DogInitScreen extends StatelessWidget {
  const DogInitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '강아지 정보 초기화',
        isDrawer: false,
        body: Center(child: Text('강아지 정보를 초기화 하시겠어요?')));
  }
}
