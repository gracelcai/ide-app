import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:provider/provider.dart';

class ProjectPeople extends StatefulWidget {
  final String id;
  const ProjectPeople({Key? key, required this.id}) : super(key: key);

  @override
  State<ProjectPeople> createState() => _ProjectPeopleState();
}

class _ProjectPeopleState extends State<ProjectPeople> {
  TextEditingController emailTextController = TextEditingController();
  // final roles =
  //     FirebaseFirestore.instance.collection("projects").doc(widget.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
            controller: emailTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              context.read<DatabaseService>().addProjectMembers(
                    widget.id,
                    emailTextController.text,
                  );
              //also needs to somehow make a project that shows up in home page
            },
            child: const Text('Add Member'),
          ),
        ),
      ],
    ));
  }
  // Widget members(Map<String, dynamic> members) {
  //   return ListView.builder(
  //       // Let the ListView know how many items it needs to build.
  //       itemCount: members.length,
  //       // Provide a builder function. This is where the magic happens.
  //       // Convert each item into a widget based on the type of item it is.
  //       itemBuilder: (context, index) {
  //         final data = members[index];

  //         // print(data.length);
  //         return ListTile(
  //           title: Text(data["title"]),
  //           subtitle: Text(data["description"]),
  //           onTap: () async {
  //             String id = await getId(index);
  //             // print(id);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProjectTabs(
  //                         id: id,
  //                       )), // pass in id or data - data easier, but should get id
  //             );
  //           },
  //           onLongPress: () {
  //             // delete?
  //           },
  //         );
  //       },
  //     )),

  // }
}
