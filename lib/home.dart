import 'package:flutter/material.dart';
// import 'package:ide_app/authentication_service.dart';
import 'package:ide_app/new_project.dart';
import 'package:ide_app/projects.dart';
// import 'package:provider/provider.dart';
// import 'package:ide_app/calendar_page.dart';
// import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';

List<Project> myProjects = [];

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projects Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewProject()),
            );
          },
          child: const Text('New Project'),
        ),
      ),
      drawer: SideMenu(),
    );
  }
}
