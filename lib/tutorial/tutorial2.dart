import 'package:flutter/material.dart';

// 외부 패키지
import 'package:get/get.dart';
import 'tutorial1.dart'; // getx
import 'tutorial3.dart'; // getx

class Tutorial2 extends StatelessWidget {
  const Tutorial2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(alignment: Alignment.center, children: <Widget>[
        Text(
          '2',
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
                            onPressed: () => Get.off(Tutorial1(),
                                transition: Transition.fadeIn),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 35,
                            ))),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                        child: IconButton(
                            onPressed: () => Get.off(Tutorial3()),
                            icon: Icon(Icons.arrow_forward_ios, size: 35)))
                  ],
                )))
      ])),
    );
  }
}
