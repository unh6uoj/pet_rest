import 'package:flutter/material.dart';
import 'package:pet/main.dart';

// sqlite
import 'package:pet/sqlite.dart';

// Calendar
import 'package:table_calendar/table_calendar.dart';

// Provider
import 'package:provider/provider.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('기록'),
            backgroundColor: Colors.green[500],
            leading: Icon(Icons.menu)),
        body: Column(children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          ),
          Expanded(
            child: HistoryListView(),
          )
        ]));
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  // sqlite에서 받아온 데이터 저장
  List<History> histDatas = [];

  // 각 데이터들이 들어갈 Row위젯
  // 하단의 Box가 생성될 때 초기화
  List<Widget> histRows = [];

  // histRow가 포함되는 위젯
  // 일일별로 하나의 Box
  List<Widget> histBoxs = [];

  // 현재 가져오고 있는 날짜 데이터
  String curDate = '';

  @override
  void initState() {
    super.initState();

    Provider.of<LogProvider>(context, listen: false)
        .getAllData()
        .then((value) => setState(() {
              histRows = [];
              histDatas = value;
              curDate = value[0].date;

              addBoxHeader(curDate);

              // 가져온 데이터들을 나눠주는 부분
              for (int i = 0; i < histDatas.length; i++) {
                if (histDatas[i].date != curDate) {
                  // 리스트에 그냥 add하면 setState가 호출되지 않는다.
                  // 이렇게 새로운 리스트를 생성 해야한다.
                  // ...은 리스트의 모든 요소를 가져온다
                  histBoxs = [...histBoxs, (HistoryBox(histRowList: histRows))];
                  histRows = [];

                  addBoxHeader(histDatas[i].date);

                  curDate = histDatas[i].date;
                }

                histRows.add(Row(
                  children: <Widget>[
                    // Expanded(
                    //   child: Text(histDatas[i].date),
                    // ),
                    Expanded(
                      child: Text(histDatas[i].activity),
                    )
                  ],
                ));

                if (i == histDatas.length - 1) {
                  histBoxs.add(HistoryBox(histRowList: histRows));
                }
              }
            }));

    // 위젯이 만들어지면 실행됨
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  void addBoxHeader(String date) {
    // 문자열 나누기
    List splitedDate = date.split(" ");

    // 날짜 삽입(header)
    histRows.add(Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
              height: 30,
              child: Text(
                splitedDate[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: histBoxs);
  }
}

class HistoryBox extends StatefulWidget {
  const HistoryBox({Key? key, required this.histRowList}) : super(key: key);

  final List<Widget> histRowList;

  @override
  _HistoryBoxState createState() => _HistoryBoxState(histRowList: histRowList);
}

class _HistoryBoxState extends State<HistoryBox> {
  final List<Widget>? histRowList;

  _HistoryBoxState({this.histRowList});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: histRowList as List<Widget>,
            )));
  }
}
