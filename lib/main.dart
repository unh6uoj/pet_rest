import 'package:flutter/material.dart';

import 'screen/screen_home.dart';
import 'screen/screen_log.dart';
import 'screen/screen_info.dart';

// getx
import 'package:get/get.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().whenComplete(() {
      final FirebaseMessaging _firebaseMessasing = FirebaseMessaging.instance;

      _firebaseMessasing.getToken().then((value) => print(value));
    });

    return GetMaterialApp(
      color: Colors.lightGreen[50],
      title: 'Pet Station',
      theme: ThemeData(primaryColor: Colors.green),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [HomeScreen(), LogScreen(), InfoScreen()],
            ),
            bottomNavigationBar: TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: '홈',
                  ),
                  Tab(
                    icon: Icon(Icons.list_alt),
                    text: '로그',
                  ),
                  Tab(
                    icon: Icon(Icons.person_outline),
                    text: '정보',
                  )
                ]),
          )),
    );
  }
}
