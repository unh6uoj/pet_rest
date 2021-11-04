import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pet/screen/scaffold.dart';
import 'package:pet/screen/screen_info.dart';

class DogInitScreen extends StatelessWidget {
  const DogInitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red,
      child: Container(
        width: 100,
        height: 100,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
      ),
    );
  }
}
