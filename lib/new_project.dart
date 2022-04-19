import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/home.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class NewProject extends StatefulWidget {
  // final Function() notifyParent;
  NewProject({Key? key}) : super(key: key);
  @override
  State<NewProject> createState() => _NewProjectState();
}

@override
class _NewProjectState extends State<NewProject> {
  // TODO: implement createState
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController goalsTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool validate = false;
    return Scaffold(
        appBar: AppBar(title: Text("New Project")),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Project Description',
                  ),
                  controller: descriptionTextController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Project Goals',
                  ),
                  controller: goalsTextController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Creating Project...')),
                      );
                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                      await context.read<DatabaseService>().createProject(
                          titleTextController.text,
                          descriptionTextController.text,
                          goalsTextController.text,
                          AuthenticationService(_firebaseAuth).getUser()!);
                      //also needs to somehow make a project that shows up in home page
                      Navigator.pop(context);

                      // widget.notifyParent();

                    }
                  },
                  child: const Text('Create Project'),
                ),
              )
            ],
          ),
        ));
  }
}
