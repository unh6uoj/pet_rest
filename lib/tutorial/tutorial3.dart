import 'package:flutter/material.dart';

// 외부 패키지
import 'package:get/get.dart';
import 'tutorial2.dart';
import 'tutorial4.dart'; // getx

class Tutorial3 extends StatelessWidget {
  const Tutorial3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(alignment: Alignment.center, children: <Widget>[
        Text(
          '3',
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
                            onPressed: () => Get.off(Tutorial2()),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 35,
                            ))),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                        child: IconButton(
                            onPressed: () => Get.off(Tutorial4()),
                            icon: Icon(Icons.arrow_forward_ios, size: 35)))
                  ],
                )))
      ])),
    );
  }
}
