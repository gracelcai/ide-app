import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/project_files.dart';
import 'package:ide_app/project_home.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:ide_app/project_people.dart';

// void main() {
//   runApp(ProjectTabs());
// }

class ProjectTabs extends StatefulWidget {
  final String id;
  ProjectTabs({Key? key, required this.id}) : super(key: key);

  final DocumentReference projectDoc =
      FirebaseFirestore.instance.collection("projects").doc();

  @override
  State<ProjectTabs> createState() => _ProjectTabsState();
}

class _ProjectTabsState extends State<ProjectTabs> {
  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> data = getData(widget.id);
    return FutureBuilder<Map<String, dynamic>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildWait();
        }

        var app = Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
          ),
          child: _buildPage(widget.id, snapshot.data!),
        );
        return app;
      },
    );
  }
}

Widget _buildPage(String id, Map<String, dynamic> data) {
  return MaterialApp(
    home: DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Overview',
              ),
              Tab(
                text: 'Resources',
              ),
              Tab(
                text: 'Schedule',
              ),
              Tab(
                text: 'Discussions',
              ),
              Tab(
                text: 'People',
              ),
            ],
          ),
          title: Text(data["title"]),
        ),
        body: TabBarView(
          children: [
            ProjectHome(id: id, data: data), //replace with pagewidgets
            ProjectFiles(id: id), //put in separate files?
            Text('will display the project schedule'),
            Text('will allow you to communicate with your group'),
            ProjectPeople(id: id),
          ],
        ),
        drawer: SideMenu(),
      ),
    ),
  );
}

Widget _buildWait() {
  return Scaffold(
    appBar: AppBar(title: Text('Loading...')),
    body: Center(child: CircularProgressIndicator()),
  );
}

Future<Map<String, dynamic>> getData(String id) async {
  DocumentReference project =
      FirebaseFirestore.instance.collection("projects").doc(id);

  DocumentSnapshot snapshot = await project.get();
  final data = snapshot.data() as Map<String, dynamic>;
  print(data);
  return data;
}
