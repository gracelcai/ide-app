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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _projectsStream =
      FirebaseFirestore.instance.collection('projects').snapshots();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  @override
  Widget build(BuildContext context) {
    List<DocumentReference> projectRefs = [];
    DocumentReference userDoc = context.read<DatabaseService>().getUserDoc()
        as DocumentReference<Object?>;
    userDoc.get().then((value) => () {
          List.from(value['projects']).forEach((element) {
            //then add the data to the List<Offset>, now we have a type Offset
            projectRefs.add(element);
          });
        });
    return Scaffold(
      appBar: AppBar(title: const Text("Projects Home")),
      // body: Center(
      //     child: ListView.builder(
      //   // Let the ListView know how many items it needs to build.
      //   itemCount: projectRefs.length,
      //   // Provide a builder function. This is where the magic happens.
      //   // Convert each item into a widget based on the type of item it is.
      //   itemBuilder: (context, index) {
      //     final ref = projectRefs[index];
      //     DocumentSnapshot<Object?> project =
      //         await projects.doc(ref.id).get();
      //     var data = project.data() as Map<String, dynamic>;
      //     print(data);
      //     return ListTile(
      //       title: Text(data["title"]),
      //       subtitle: Text(data["description"]),
      //     );
      //   },
      // )),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['full_name']),
                subtitle: Text(data['company']),
              );
            }).toList(),
          );
        },
      ),
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
    );
  }
}
