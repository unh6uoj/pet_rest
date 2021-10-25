import 'package:flutter/material.dart';

// screen
// tutorial
import 'package:pet/tutorial/tutorial1.dart';

// 외부 패키지
import 'package:get/get.dart'; // getx
import 'package:url_launcher/url_launcher.dart'; // url_launcher

Drawer myDrawer = Drawer(
    child: ListView(
  physics: const NeverScrollableScrollPhysics(),
  padding: EdgeInsets.zero,
  children: [
    DrawerHeader(
        decoration: BoxDecoration(color: Colors.green),
        child: Row(children: <Widget>[
          Image.asset(
            'images/peterest_logo.png',
            width: 50,
          ),
          SizedBox(width: 10),
          Text(
            '바로가기',
            style: TextStyle(fontSize: 23),
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
    ListTile(
        title: const Text('사용법', style: TextStyle(fontSize: 20)),
        onTap: () => Get.to(Tutorial1())),
    SizedBox(height: 300),
    ListTile(
        title: const Text('앱 버전 0.1v', style: TextStyle(fontSize: 16)),
        onTap: () {}),
  ],
));

void _launchURL(_url) async {
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
