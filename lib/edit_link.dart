import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class EditLink extends StatefulWidget {
  // final Function() notifyParent;
  final String projectId;
  final String linkId;
  EditLink({Key? key, required this.projectId, required this.linkId})
      : super(key: key);
  @override
  State<EditLink> createState() => _EditLinkState();
}

@override
class _EditLinkState extends State<EditLink> {
  // TODO: implement createState

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> projectData =
        getProjectData(widget.projectId, widget.linkId);

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
        TextEditingController(text: data["name"]);
    TextEditingController descriptionTextController =
        TextEditingController(text: data["description"]);
    TextEditingController linkTextController =
        TextEditingController(text: data["link"]);
    return Scaffold(
      appBar: AppBar(title: Text("Edit Link")),
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
                  labelText: 'Name',
                ),
                controller: titleTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Description',
                ),
                controller: descriptionTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Link',
                ),
                controller: linkTextController,
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
                    context.read<DatabaseService>().updateLink(
                          widget.projectId,
                          widget.linkId,
                          titleTextController.text,
                          descriptionTextController.text,
                          linkTextController.text,
                        );
                    //also needs to somehow make a project that shows up in home page
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Link'),
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

  Future<Map<String, dynamic>> getProjectData(
      String projectId, String linkId) async {
    DocumentSnapshot project = await FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .collection("links")
        .doc(linkId)
        .get();
    final data = project.data() as Map<String, dynamic>;
    return data;
  }
}
