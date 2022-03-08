import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/calendar_page.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:ide_app/widgets/toDoList.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks")),
      body: TodoList(),
      drawer: SideMenu(),
    );
  }
}
