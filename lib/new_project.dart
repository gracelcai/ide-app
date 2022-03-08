import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/myTaskPage.dart';
import 'package:ide_app/database_service.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class NewProject extends StatelessWidget {
  const NewProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Project")),
      body: ProjectInfo(),
    );
  }
}

class ProjectInfo extends StatelessWidget {
  ProjectInfo({Key? key}) : super(key: key);
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController goalsTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Project Title',
            ),
            controller: titleTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Project Description',
            ),
            controller: descriptionTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Project Goals',
            ),
            controller: goalsTextController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              context.read<DatabaseService>().createProject(
                  titleTextController.text,
                  descriptionTextController.text,
                  goalsTextController.text,
                  AuthenticationService(_firebaseAuth).getUser()!);
              //also needs to somehow make a project that shows up in home page
              Navigator.pop(context);
            },
            child: const Text('Create Project'),
          ),
        )
      ],
    );
  }
}
