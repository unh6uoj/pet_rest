import 'package:flutter/material.dart';
import 'package:pet/screen/scaffold.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
        title: '공지사항',
        isDrawer: false,
        body: Center(
            child: Text(
          '공지사항이 없어요',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        )));
  }
}
