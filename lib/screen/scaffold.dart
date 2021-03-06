import 'package:flutter/material.dart';

// screen

// 외부 패키지
import 'package:get/get.dart'; // getx
import 'package:url_launcher/url_launcher.dart'; // url_launcher

Drawer myDrawer = Drawer(
    child: ListView(
  physics: const NeverScrollableScrollPhysics(),
  padding: EdgeInsets.zero,
  children: [
    DrawerHeader(
        decoration: BoxDecoration(color: Color(0xFF049A5B)),
        child: Row(children: <Widget>[
          Image.asset(
            'images/peterest_logo.png',
            width: 50,
          ),
          SizedBox(width: 10),
          Text(
            '바로가기',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          )
        ])),
    ListTile(
        title: Row(children: <Widget>[
          Image.asset('images/insta_logo2.png', width: 100)
        ]),
        onTap: () => _launchURL('https://www.instagram.com/peterest.co/')),
    ListTile(
        title: const Text('스마트스토어', style: TextStyle(fontSize: 20)),
        onTap: () => _launchURL('https://smartstore.naver.com/peterest')),
    SizedBox(height: 380),
    ListTile(
        title: const Text('앱 버전 0.1v', style: TextStyle(fontSize: 16)),
        onTap: () {}),
  ],
));

void _launchURL(_url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class MyPage extends StatelessWidget {
  MyPage(
      {Key? key, required this.title, this.isDrawer = true, required this.body})
      : super(key: key);

  final String title;
  final Widget body;
  final bool isDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF0F0F0),
        appBar: AppBar(title: Text(title), backgroundColor: Color(0xFF049A5B)),
        drawer: isDrawer ? myDrawer : null,
        body: body);
  }
}
