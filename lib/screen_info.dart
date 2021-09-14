import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [LoadCellInfo()],
      ),
    ));
  }
}

class LoadCellInfo extends StatefulWidget {
  const LoadCellInfo({Key? key}) : super(key: key);

  @override
  _LoadCellInfoState createState() => _LoadCellInfoState();
}

class _LoadCellInfoState extends State<LoadCellInfo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
