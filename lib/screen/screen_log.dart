import 'package:flutter/material.dart';
import 'package:pet/main.dart';

// drawer
import 'package:pet/screen/scaffold.dart';

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
    return MyPage(
        title: '기록',
        body: Column(children: <Widget>[
          CalendarArea(),
          // SelectHistoryBtns(),
          SizedBox(height: 10),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(5),
            child: HistoryList(),
          )),
        ]));
  }
}

class CalendarArea extends StatelessWidget {
  CalendarArea({Key? key}) : super(key: key) {
    initializeDateFormatting();
  }

  final LogScreenController logScreenController =
      Get.put(LogScreenController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => TableCalendar(
        // 한글
        locale: 'ko-KR',
        // calendar 날짜 정의
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: logScreenController._focusedDay.value,
        calendarStyle: CalendarStyle(
            selectedTextStyle: TextStyle(),
            selectedDecoration: logScreenController.isMonthData.value &&
                    !isSameDay(
                        logScreenController._focusedDay.value, DateTime.now())
                ? BoxDecoration(
                    color: Colors.white.withOpacity(0), shape: BoxShape.circle)
                : BoxDecoration(color: Colors.green, shape: BoxShape.circle)),

        // calendar format 정의
        calendarFormat: logScreenController._calendarFormat.value,
        availableCalendarFormats: const {
          CalendarFormat.month: '한달',
          CalendarFormat.twoWeeks: '2주',
        },
        // calendar format 변경 시 setState
        onFormatChanged: (format) {
          logScreenController._calendarFormat.value = format;
        },
        onPageChanged: (datetime) {
          logScreenController.curCalendarDate.value =
              datetime.toString().split(".")[0];

          logScreenController
              .getDataByMonth(logScreenController.curCalendarDate.value)
              .then((value) {
            logScreenController.setHistoryBox(value);
          });
        },
        // foramt변경 animation
        formatAnimationCurve: Curves.easeInOutCirc,
        formatAnimationDuration: Duration(milliseconds: 300),
        onDaySelected: (selectedDay, focusedDay) {
          logScreenController._selectedDay.value = selectedDay;
          logScreenController._focusedDay.value = focusedDay;

          // 현재 선택된 날짜와 누른 날짜가 같을 때
          if (selectedDay.toString().split(" ")[0] ==
              logScreenController.curCalendarDate.value) {
            // 달 별 데이터 보여주기를 (not 달 별 데이터 보여주기)로 변경
            logScreenController.isMonthData.value =
                !logScreenController.isMonthData.value;

            // 날짜 추출 [1]에는 시간 담김
            logScreenController.curCalendarDate.value =
                selectedDay.toString().split(" ")[0];

            // 현재 달 별 데이터일때
            if (logScreenController.isMonthData.value) {
              // 달 별 데이터 출력
              logScreenController
                  .getDataByMonth(logScreenController.curCalendarDate.value)
                  .then((value) => logScreenController.setHistoryBox(value));
              // 일 별 데이터 출력
            } else {
              logScreenController
                  .getDataByDay(logScreenController.curCalendarDate.value)
                  .then((value) => logScreenController.setHistoryBox(value));
            }
          } else {
            logScreenController.isMonthData.value = false;
            // 날짜 추출 [1]에는 시간 담김
            logScreenController.curCalendarDate.value =
                selectedDay.toString().split(" ")[0];

            // 일 별 데이터 출력
            logScreenController
                .getDataByDay(logScreenController.curCalendarDate.value)
                .then((value) => logScreenController.setHistoryBox(value));
          }
        },
        selectedDayPredicate: (day) =>
            isSameDay(day, logScreenController._selectedDay.value)));
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
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Color(0xFF17D282),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.5,
                  blurRadius: 0.5,
                  offset: Offset(0, 3),
                  color: Colors.grey.withOpacity(0.4))
            ]),
        child: Column(children: histRowList));
  }
}

class LogScreenController extends GetxController {
  var curCalendarDate = DateTime.now().toString().split(" ")[0].obs;
  var resultBoxes = <HistoryBox>[].obs;

  var isMonthData = true.obs;

  var _calendarFormat = CalendarFormat.month.obs;
  var _selectedDay = DateTime.now().obs;
  var _focusedDay = DateTime.now().obs;

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

  // 일별 데이터 가져오기
  Future<List<History>> getDataByDay(curDate) {
    Future<List<History>> data = DBHelper().getHistorysByDay(curDate);

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
