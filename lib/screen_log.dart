import 'package:flutter/material.dart';
import 'package:pet/sqlite.dart';

// Calendar
import 'package:table_calendar/table_calendar.dart';

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
        // child: Text(DBHelper().getAllHistorys()))
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
  String curDate = '1';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper().getAllHistorys(),
        builder: (BuildContext context, AsyncSnapshot<List<History>> snapshot) {
          if (snapshot.hasData) {
            List<Widget> histRowList = [];
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  History item = snapshot.data![index];
                  if (curDate != item.date) {
                    curDate = item.date;
                    histRowList = [];
                    return FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: histRowList,
                            )));
                  }
                  histRowList.add(
                    Row(
                      children: <Widget>[
                        Expanded(child: Text(item.activity)),
                        Expanded(child: Text(item.date))
                      ],
                    ),
                  );
                  if (index == snapshot.data!.length - 1) {
                    return FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: histRowList,
                            )));
                  }
                  return Container();
                });
          } else {
            return (Center(child: CircularProgressIndicator()));
          }
        });
  }
}
