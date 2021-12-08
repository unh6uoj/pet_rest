import 'package:flutter/material.dart';

import 'screen/screen_home.dart';
import 'screen/screen_log.dart';
import 'screen/screen_info.dart';

// getx
import 'package:get/get.dart';

// get_storage
import 'package:get_storage/get_storage.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) => {print(value)});

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pet Station',
      theme: ThemeData(primaryColor: Color(0xFFF0F0F0)),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Color(0xFF049A5B),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [HomeScreen(), LogScreen(), InfoScreen()],
            ),
            bottomNavigationBar: TabBar(
                indicatorWeight: 4,
                labelColor: Color(0xFFFFFFFF),
                indicatorColor: Color(0xFFFFFFFF),
                tabs: [
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: '홈',
                  ),
                  Tab(
                    icon: Icon(Icons.list_alt),
                    text: '기록',
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
