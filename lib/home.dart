import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/database_service.dart';
// import 'package:ide_app/authentication_service.dart';
import 'package:ide_app/new_project.dart';
import 'package:ide_app/projects.dart';
// import 'package:provider/provider.dart';
// import 'package:ide_app/calendar_page.dart';
// import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:ide_app/widgets/projectInnerPages.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

List<Project> myProjects = [];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> projectRefs;
  refresh() {
    setState(() {
      print("refresh");
      build(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List> projectRefs = getProjects();
    return FutureBuilder<List>(
      future: projectRefs,
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
          child: _buildPage(snapshot.data!, true),
        );
        return app;
      },
    );
  }

  Widget _buildPage(List projectRefs, bool listView) {
    return Scaffold(
      //need to use projects list from user doc!!
      appBar: AppBar(title: const Text("Projects Home")),
      body: Center(
          child: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: projectRefs.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          Map<String, dynamic> data = projectRefs[index];

          // print(data.length);
          if (listView) {
            return ListTile(
              title: Text(data["title"]),
              subtitle: Text(data["description"]),
              onTap: () async {
                String id = await getId(index);
                // print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectTabs(
                            id: id,
                          )), // pass in id or data - data easier, but should get id
                );
              },
              onLongPress: () {
                // delete?
              },
            );
          } else {
            return Card(
              color: Colors.white,
              shadowColor: Colors.white70,
              elevation: 10.0,
              child: Column(
                children: [Text(data["title"]), Text(data["description"])],
              ),
              // onTap: () async {
              //   String id = await getId(index);
              //   // print(id);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ProjectTabs(
              //               id: id,
              //             )), // pass in id or data - data easier, but should get id
              //   );
              // },
            );
          }
        },
      )),

      drawer: SideMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewProject(
                      notifyParent: refresh, //not working
                    )),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _buildWait() {
  return Scaffold(
    appBar: AppBar(title: Text('Loading...')),
    body: Center(child: CircularProgressIndicator()),
  );
}

Future<List> getProjects() async {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference projects = _firebaseFirestore.collection('projects');
  final databaseService = DatabaseService(_firebaseFirestore);
  String docId = await databaseService.getUserId();
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(docId);
  DocumentSnapshot snapshot = await userDoc.get();
  final data = snapshot.data() as Map<String, dynamic>;
  // print(data["projects"]);

  List projectRefs = data["projects"];
  List<Map<String, dynamic>> projectData = [];
  for (DocumentReference ref in projectRefs) {
    DocumentSnapshot project = await projects.doc(ref.id).get();
    final data = project.data() as Map<String, dynamic>;

    projectData.add(data);
  }
  // print(projectData);
  return projectData;
}

Future<String> getId(int index) async {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference projects = _firebaseFirestore.collection('projects');
  final databaseService = DatabaseService(_firebaseFirestore);
  String docId = await databaseService.getUserId(); // ERROr
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(docId);
  DocumentSnapshot snapshot = await userDoc.get();
  final data = snapshot.data() as Map<String, dynamic>;
  // print(data["projects"]);

  List projectRefs = data["projects"];
  List<Map<String, dynamic>> projectData = [];
  DocumentReference ref = projectRefs[index];
  return ref.id;
}
