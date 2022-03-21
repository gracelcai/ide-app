import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/project_home.dart';

// void main() {
//   runApp(ProjectTabs());
// }

class ProjectTabs extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  ProjectTabs({Key? key, required this.id, required this.data})
      : super(key: key);

  final DocumentReference projectDoc =
      FirebaseFirestore.instance.collection("projects").doc();

  @override
  State<ProjectTabs> createState() => _ProjectTabsState();
}

class _ProjectTabsState extends State<ProjectTabs> {
  @override
  Widget build(BuildContext context) {
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
                  text: 'Files',
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
            title: Text(widget.data["title"]),
          ),
          body: TabBarView(
            children: [
              ProjectHome(
                  id: widget.id, data: widget.data), //replace with pagewidgets
              Text(
                  'will display your shared files and links'), //put in separate files?
              Text('will display the project schedule'),
              Text('will allow you to communicate with your group'),
              Text('will show your groupmembers'),
            ],
          ),
        ),
      ),
    );
  }
}
