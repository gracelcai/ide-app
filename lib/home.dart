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

List<Project> myProjects = [];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> projectRefs;
  bool listView = true;
  refresh() {
    setState(() {
      print("refresh");
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List> projectRefs = getProjects();
    return FutureBuilder<List>(
      future: projectRefs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildWait();
        }

        var app = Theme(
          data: ThemeData(
            primarySwatch: Colors.blue,
          ),
          child: buildPage(snapshot.data!),
        );
        return app;
      },
    );
  }

  Widget buildPage(List projectRefs) {
    List<bool> isSelected = <bool>[true, false];
    return Scaffold(
      //need to use projects list from user doc!!
      appBar: AppBar(
        title: const Text("Projects Home"),
        actions: [
          ToggleButtons(
            children: const <Widget>[
              Icon(Icons.list),
              Icon(Icons.window),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
                listView = isSelected[0];
              });
            },
            isSelected: isSelected,
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: projectRefs.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          Map<String, dynamic> data = projectRefs[index];
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
            return Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.all(10.0),
              width: 100,
              child: Card(
                margin: EdgeInsets.all(8.0),
                color: Colors.white,
                shadowColor: Colors.white70,
                elevation: 10.0,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(data["title"]),
                        Text(data["description"])
                      ],
                    ),
                  ),
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
                ),
              ),
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

Widget buildWait() {
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
