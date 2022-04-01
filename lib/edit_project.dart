import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class EditProject extends StatefulWidget {
  // final Function() notifyParent;
  final String id;
  EditProject({Key? key, required this.id}) : super(key: key);
  @override
  State<EditProject> createState() => _EditProjectState();
}

@override
class _EditProjectState extends State<EditProject> {
  // TODO: implement createState

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> projectData = getProjectData(widget.id);

    bool validate = false;
    return FutureBuilder<Map<String, dynamic>>(
        future: projectData,
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
        });
  }

  Widget buildPage(Map<String, dynamic> data) {
    TextEditingController titleTextController =
        TextEditingController(text: data["title"]);
    TextEditingController descriptionTextController =
        TextEditingController(text: data["description"]);
    TextEditingController goalsTextController =
        TextEditingController(text: data["goals"]);
    return Scaffold(
      appBar: AppBar(title: Text("Edit Project")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                    context.read<DatabaseService>().updateProject(
                          widget.id,
                          titleTextController.text,
                          descriptionTextController.text,
                          goalsTextController.text,
                        );
                    //also needs to somehow make a project that shows up in home page
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Project'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildWait() {
    return Scaffold(
      appBar: AppBar(title: Text('Loading...')),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<Map<String, dynamic>> getProjectData(String id) async {
    DocumentSnapshot project =
        await FirebaseFirestore.instance.collection("projects").doc(id).get();
    final data = project.data() as Map<String, dynamic>;
    return data;
  }
}
