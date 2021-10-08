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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper().getAllHistorys(),
        builder: (BuildContext context, AsyncSnapshot<List<History>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  History item = snapshot.data![index];

                  return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        DBHelper().deleteHistory(item.id);
                        setState(
                          () {},
                        );
                      },
                      child: Center(
                        child: Text(item.activity),
                      ));
                });
          } else {
            return (Center(child: CircularProgressIndicator()));
          }
        });
  }
}
