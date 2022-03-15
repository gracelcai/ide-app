import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/database_service.dart';
// import 'package:ide_app/authentication_service.dart';
import 'package:ide_app/new_project.dart';
import 'package:ide_app/projects.dart';
// import 'package:provider/provider.dart';
// import 'package:ide_app/calendar_page.dart';
// import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

List<Project> myProjects = [];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  var projectRefs = [];
  @override
  Widget build(BuildContext context) {
    Future<String> docId = context.read<DatabaseService>().getUserDocId();
    docId.then((value) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("users").doc(value);

      userDoc.get().then((value) {
        final data = value.data() as Map<String, dynamic>;
        // print(data["projects"]);

        projectRefs = data["projects"];
        // print(projectRefs.length);
      });
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        //need to use projects list from user doc!!
        appBar: AppBar(title: const Text("Projects Home")),
        body: Center(
            child: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: projectRefs.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final ref = projectRefs[index];
            DocumentSnapshot project =
                projects.doc(ref.id).get() as DocumentSnapshot;

            Map<String, dynamic> data = project.data() as Map<String, dynamic>;
            // print(data.length);
            return ListTile(
              title: Text(data["title"]),
              subtitle: Text(data["description"]),
            );
          },
        )),

        drawer: SideMenu(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewProject()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );

    // final _projectsStream =
    //     FirebaseFirestore.instance.collection('users').doc(docId).snapshots();
  }
}
