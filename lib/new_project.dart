import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';

class NewProject extends StatelessWidget {
  const NewProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Project")),
      body: const Center(
        child: Text('create a new Project'),
      ),
    );
  }
}
