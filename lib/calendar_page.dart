import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:ide_app/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage> {
  static final List<Meeting> meetings = <Meeting>[];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Calendar")),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(meetings),
        showNavigationArrow: true,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
      drawer: SideMenu(),
    );
  }
}

void addMeeting(Meeting m) {
  if (!_CalendarState.meetings.contains(m)) {
    print(m.eventName);
    _CalendarState.meetings.add(m);
  }
}

void resetMeetingList() {
  _CalendarState.meetings.clear();
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  //final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // final databaseService = DatabaseService(_firebaseFirestore);
  // String docId = await databaseService.getUserDocId(); // ERROr
  // CollectionReference tasks = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(docId)
  //     .collection('tasks');

  // StreamBuilder(
  //   stream: tasks.snapshots(),
  //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //     if (snapshot.hasError) {
  //       print("Error with snapshot");
  //     }
  //     if (!snapshot.hasData) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     }
  //     return ListView(
  //       children: snapshot.data!.docs.map((document) {
  //         meetings.add(document['task']);
  //         return Center(
  //           child: CheckboxListTile(
  //               title: Text(document['task']),
  //               subtitle: Text(document['month'].toString() +
  //                   "/" +
  //                   document['day'].toString()),
  //               value: document['complete'],
  //               secondary: Container(
  //                 height: 50,
  //                 width: 50,
  //               ),
  //               onChanged: (bool? value) {
  //                 setState(() {
  //                   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //                   databaseService.toggleTask(document.id, value!);
  //                 });
  //               }),
  //         );
  //       }).toList(),
  //     );
  //   },
  // );

  // final DateTime today = DateTime.now();
  // final DateTime startTime =
  //     DateTime(today.year, today.month, today.day, 9, 0, 0);
  // final DateTime endTime = startTime.add(const Duration(hours: 2));
  // meetings.add(Meeting(
  //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
