import 'package:flutter/material.dart';

import 'screen_home.dart';
import 'screen_log.dart';
import 'screen_info.dart';
import 'sqlite.dart';

// getx
import 'package:get/get.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  runApp(MyApp());

  DBHelper()
      .createData(History(date: '2021-10-10 10:10:11', activity: 'assas'));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().whenComplete(() {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      _firebaseMessaging.getToken().then((token) {
        print(token); // Print the Token in Console
      });
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
