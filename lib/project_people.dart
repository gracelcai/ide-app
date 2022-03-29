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
    Future<List> members = getMembers(widget.id);
    print(members);
    return FutureBuilder<List>(
        future: members,
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
            child: _buildPage(snapshot.data!),
          );
          return app;
        });
  }

  Widget _buildWait() {
    return Scaffold(
      appBar: AppBar(title: Text('Loading...')),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPage(List members) {
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
        membersList(members),
      ],
    ));
  }

  Widget membersList(List members) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: members.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final data = members[index];

          // print(data.length);
          return ListTile(
            title: Text(data["name"]),
            subtitle: Text(data["email"]),
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
            onLongPress: () {
              // delete?
            },
          );
        },
      ),
    );
  }
}

Future<List> getMembers(String projectId) async {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference projects = _firebaseFirestore.collection('projects');
  CollectionReference users = _firebaseFirestore.collection("users");
  DocumentReference project = projects.doc(projectId);
  DocumentSnapshot snapshot = await project.get();
  final data = snapshot.data() as Map<String, dynamic>;

  print(data["members"]);

  List memberRefs = data["members"];
  List<Map<String, dynamic>> memberData = <Map<String, dynamic>>[];
  print(memberRefs.length);
  for (DocumentReference ref in memberRefs) {
    print('ref');
    DocumentSnapshot member = await ref.get();
    final data = member.data() as Map<String, dynamic>;
    memberData.add(data); //change to email or name and role not adding!!
  }
  // memberRefs.forEach((key, value) async {
  //   print(key);
  //   DocumentSnapshot member = await users.doc(key).get();
  //   final data = member.data() as Map<String, dynamic>;
  //   memberData.add(data); //change to email or name and role not adding!!
  // });

  print(memberData);
  return memberData;
}
