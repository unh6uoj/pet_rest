import 'package:flutter/material.dart';
import 'package:pet/main.dart';

// drawer
import 'package:pet/drawer.dart';

// sqlite
import 'package:pet/sqlite.dart';

// Calendar
import 'package:table_calendar/table_calendar.dart';
// 한글 달력 출력을 위한 패키지
import 'package:intl/date_symbol_data_local.dart';

// Provider
import 'package:provider/provider.dart';

class LogScreen extends StatelessWidget {
  LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('기록'), backgroundColor: Colors.green[500]),
        drawer: myDrawer,
        body: Column(children: <Widget>[
          CalendarArea(),
          Expanded(
            child: HistoryListView(),
          )
        ]));
  }
}

class CalendarArea extends StatefulWidget {
  const CalendarArea({Key? key}) : super(key: key);

  @override
  _CalendarAreaState createState() => _CalendarAreaState();
}

class _CalendarAreaState extends State<CalendarArea> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    // 한글 달력 출력을 위한 함수
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // 한글
      locale: 'ko-KR',
      // calendar 날짜 정의
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      // calendar format 정의
      calendarFormat: _calendarFormat,
      availableCalendarFormats: const {
        CalendarFormat.month: '한달',
        CalendarFormat.twoWeeks: '2주',
      },
      // calendar format 변경 시 setState
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      // foramt변경 animation
      formatAnimationCurve: Curves.easeInOutCirc,
      formatAnimationDuration: Duration(milliseconds: 300),
    );
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
  List<Widget> histBoxes = [];

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
              curDate = histDatas[histDatas.length - 1].date.split(" ")[0];

              // 첫 번째 box header넣기
              addBoxHeader(curDate);

              // 가져온 데이터들을 나눠주는 부분
              for (int i = histDatas.length - 1; i >= 0; i--) {
                // date값은 milliseconds 단위로 들어있기 때문에 미리 일별로 나눠줘야 한다.
                String dbDate = histDatas[i].date.split(" ")[0];
                String dbTime = histDatas[i].date.split(" ")[1];
                String dbActivity = histDatas[i].activity;

                if (dbDate != curDate) {
                  // 리스트에 그냥 add하면 setState가 호출되지 않는다.
                  // 이렇게 새로운 리스트를 생성 해야한다.
                  // ...은 리스트의 모든 요소를 가져온다.
                  histBoxes = [
                    ...histBoxes,
                    (HistoryBox(histRowList: histRows))
                  ];
                  histRows = [];

                  addBoxHeader(dbDate);

                  curDate = dbDate;
                }

                histRows.add(Row(
                  children: <Widget>[
                    // Expanded(
                    //   child: Text(histDatas[i].date),
                    // ),
                    Expanded(
                      child: Text(dbActivity),
                    ),
                    Expanded(
                      child: Text(dbTime),
                    )
                  ],
                ));

                if (i == 0) {
                  histBoxes = [
                    ...histBoxes,
                    (HistoryBox(histRowList: histRows))
                  ];
                }
              }
            }));

    // 위젯이 만들어지면 실행됨
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  void addBoxHeader(String date) {
    // 날짜 삽입(header)
    histRows.add(Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
              height: 30,
              child: Text(
                date,
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
    return ListView(children: histBoxes);
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
