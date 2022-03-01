import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Calendar")),
      body: const Center(
        child: Text(
            'where we would include a calendar compiled with all of your tasks and meetings'),
      ),
      drawer: SideMenu(),
    );
  }
}
