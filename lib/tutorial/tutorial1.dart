import 'package:flutter/material.dart';

import 'package:pet/tutorial/tutorial2.dart';

// 외부 패키지
import 'package:get/get.dart'; // getx

class Tutorial1 extends StatelessWidget {
  const Tutorial1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(alignment: Alignment.center, children: <Widget>[
        Text(
          '홈 화면의 버튼을 눌러 강아지에게 밥을 줄 수 있어요',
          style: TextStyle(fontSize: 17),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 35,
                            ))),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                        child: IconButton(
                            onPressed: () => Get.off(Tutorial2()),
                            icon: Icon(Icons.arrow_forward_ios, size: 35)))
                  ],
                )))
      ])),
    );
  }
}
