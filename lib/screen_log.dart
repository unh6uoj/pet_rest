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

// getx
import 'package:get/get.dart';

class LogScreen extends StatelessWidget {
  LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final LogScreenController logScreenController =
    //     Get.put(LogScreenController());

    return Scaffold(
        appBar: AppBar(title: Text('기록'), backgroundColor: Colors.green[500]),
        drawer: myDrawer,
        body: Column(children: <Widget>[
          CalendarArea(),
          Expanded(
            child: HistoryList(),
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
      onPageChanged: (datetime) {
        print(datetime.toString());
      },
      // foramt변경 animation
      formatAnimationCurve: Curves.easeInOutCirc,
      formatAnimationDuration: Duration(milliseconds: 300),
    );
  }
}

class HistoryList extends StatelessWidget {
  final logScreenController = Get.put(LogScreenController());

  HistoryList({Key? key}) : super(key: key) {
    logScreenController.getDataByMonth('2021-10-18').then((value) {
      logScreenController.setHistoryBox(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(children: logScreenController.resultBoxes));
  }
}

class HistoryBox extends StatelessWidget {
  HistoryBox({Key? key, required this.histRowList}) : super(key: key);

  final histRowList;

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
            child: Column(children: histRowList)));
  }
}

class LogScreenController extends GetxController {
  var resultBoxes = <HistoryBox>[].obs;

  // 모든 데이터 가져오기
  Future<List<History>> getAllData() {
    Future<List<History>> data = DBHelper().getAllHistorys();

    return data;
  }

  // 달별 데이터 가져오기
  Future<List<History>> getDataByMonth(curDate) {
    Future<List<History>> data = DBHelper().getHistorysByMonth(curDate);

    return data;
  }

  // 이 함수는 histRows에 HeaderRow를 더해주는 기능이다.
  List<Row> addBoxHeader(List<Row> targetRows, String date) {
    // 날짜 삽입(header)
    targetRows.add(Row(
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

    return targetRows;
  }

  //
  List<Row> addBoxRow(List<Row> targetRows, String date, String activity) {
    targetRows.add(Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(activity),
        ),
        Expanded(
          child: Text(date),
        )
      ],
    ));

    return targetRows;
  }

  // 데이터를 받아 일별 카드 형식으로 나누기
  setHistoryBox(historyDatas) {
    List<Row> rows = [];

    resultBoxes.clear();

    String curDate = historyDatas[historyDatas.length - 1].date.split(" ")[0];
    // 첫 번째 box header넣기
    rows = addBoxHeader(rows, curDate);

    Iterable reversedHistoryDatas = historyDatas.reversed;
    reversedHistoryDatas.forEach((history) {
      String dbDate = history.date.split(" ")[0];
      String dbTime = history.date.split(" ")[1].split(".")[0];
      String dbActivity = history.activity;

      if (dbDate != curDate) {
        resultBoxes.add(HistoryBox(histRowList: rows));
        rows = [];

        rows = addBoxHeader(rows, dbDate);
        curDate = dbDate;
      }

      rows = addBoxRow(rows, dbDate, dbActivity);
    });
  }
}
