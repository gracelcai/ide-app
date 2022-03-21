import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(ProjectTabs());
// }

class ProjectTabs extends StatefulWidget {
  late final String id;
  ProjectTabs({Key? key, required String id}) : super(key: key);

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
            title: const Text('Project Title'),
          ),
          body: const TabBarView(
            children: [
              Text(
                  'will contain your description and goals'), //replace with pagewidgets
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

class ProjectHome extends StatefulWidget {
  const ProjectHome({Key? key, required String id}) : super(key: key);

  @override
  State<ProjectHome> createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
