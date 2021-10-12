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
  List<Widget> histCards = [];
  List<History>? histDatas;
  String curDate = '';

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
    print(histDatas!.length.toString());

    for (int i = 0; i < histDatas!.length; i++) {
      histRows.add(Row(
        children: <Widget>[
          Expanded(
            child: Text(histDatas![i].date),
          ),
          Expanded(
            child: Text(histDatas![i].activity),
          )
        ],
      ));

      if (histDatas![i].date != curDate) {
        histCards
            .add(HistoryBox(histRowList: histRows, date: histDatas![i].date));
        histRows = [];
        curDate = histDatas![i].date;
      }
    }
    return ListView(children: histCards);
  }
}

class HistoryBox extends StatefulWidget {
  HistoryBox({Key? key, required this.histRowList, required this.date})
      : super(key: key);

  List<Widget> histRowList;
  final String? date;

  @override
  _HistoryBoxState createState() =>
      _HistoryBoxState(histRowList: histRowList, date: date);
}

class _HistoryBoxState extends State<HistoryBox> {
  List<Widget>? histRowList;
  final String? date;

  _HistoryBoxState({this.histRowList, this.date});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: histRowList as List<Widget>,
            )));
  }
}
