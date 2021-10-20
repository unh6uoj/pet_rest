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
    final LogScreenController logScreenController =
        Get.put(LogScreenController());

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
        logScreenController.curCalendarDate = datetime.toString().split(".")[0];

        logScreenController
            .getDataByMonth(logScreenController.curCalendarDate)
            .then((value) {
          logScreenController.setHistoryBox(value);
        });
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
    logScreenController.getDataByMonth(DateTime.now().toString()).then((value) {
      logScreenController.setHistoryBox(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => logScreenController.resultBoxes.length != 0
        ? ListView(children: logScreenController.resultBoxes)
        : Center(child: Text('데이터가 없습니다.')));
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
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: Offset(0, 3),
                      color: Colors.grey.withOpacity(0.4))
                ]),
            child: Column(children: histRowList)));
  }
}

class LogScreenController extends GetxController {
  var curCalendarDate = DateTime.now().toString().split(" ")[0];
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

  // targetRows로 들어온 List에 Row 추가
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

    History last = reversedHistoryDatas.last;
    reversedHistoryDatas.forEach((history) {
      // 데이터 나누기
      // 날짜 (YYYY-MM-DD)
      String dbDate = history.date.split(" ")[0];
      // 시간 (HH:MM:SS)
      String dbTime = history.date.split(" ")[1].split(".")[0];
      // 활동
      String dbActivity = history.activity;

      // 현재 가져온 db의 날짜와 이전 날짜가 다르다면
      if (dbDate != curDate) {
        // HistoryBox생성 후에 result에 넣기
        resultBoxes.add(HistoryBox(histRowList: rows));
        // row 초기화
        rows = [];

        // header 넣기
        rows = addBoxHeader(rows, dbDate);
        curDate = dbDate;
      }

      rows = addBoxRow(rows, dbTime, dbActivity);

      // 리스트 마지막 값은 다음 날짜와 비교가 불가능 하기 때문에
      // 리스트의 마지막 element가 있다면 HistoryBox 추가
      if (history == last) {
        resultBoxes.add(HistoryBox(histRowList: rows));
      }
    });
  }
}
