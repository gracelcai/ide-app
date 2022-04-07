import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ide_app/services/database_service.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class NewLink extends StatefulWidget {
  final Function() notifyParent;
  final String projectId;
  NewLink({Key? key, required this.projectId, required this.notifyParent})
      : super(key: key);
  @override
  State<NewLink> createState() => _NewLinkState();
}

@override
class _NewLinkState extends State<NewLink> {
  // TODO: implement createState
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController linkTextController = TextEditingController();
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
                    labelText: 'Name',
                  ),
                  controller: nameTextController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Description',
                  ),
                  controller: descriptionTextController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please copy in a link';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Link',
                  ),
                  controller: linkTextController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Creating Project...')),
                      );
                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                      context.read<DatabaseService>().createLink(
                          nameTextController.text,
                          descriptionTextController.text,
                          linkTextController.text,
                          widget.projectId);
                      //also needs to somehow make a project that shows up in home page
                      Navigator.pop(context);

                      widget.notifyParent();
                    }
                  },
                  child: const Text('Create Link'),
                ),
              )
            ],
          ),
        ));
  }
}
