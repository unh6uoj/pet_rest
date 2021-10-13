import 'package:flutter/material.dart';
import 'package:pet/main.dart';

// sqlite
import 'package:pet/sqlite.dart';

// Calendar
import 'package:table_calendar/table_calendar.dart';

// Provider
import 'package:provider/provider.dart';

String curDate = '';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  List<Widget> histRows = [];
  List<History> histDatas = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<LogProvider>(context, listen: false)
          .getAllData()
          .then((value) => setState(() {
                histRows = [];
                histDatas = value;
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    String curDate = histDatas[0].date;

    List<Widget> histCards = [];
    histRows = [];

    // 날짜 삽입(header)
    histRows.add(Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
              height: 30,
              child: Text(
                histDatas[0].date,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ],
    ));

    for (int i = 0; i < histDatas.length; i++) {
      if (histDatas[i].date != curDate) {
        histCards.add(HistoryBox(histRowList: histRows));
        histRows = [];

        // 날짜 삽입(header)
        histRows.add(Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                  height: 30,
                  child: Text(
                    histDatas[i].date,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ));
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
        histCards.add(HistoryBox(histRowList: histRows));
      }
    }
    return ListView(children: histCards);
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
