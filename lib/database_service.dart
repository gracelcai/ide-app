import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore;

  DatabaseService(this._firebaseFirestore);
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<void> createProject(String title, String description, String goals) {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members
    return projects
        .add({
          'title': title,
          'description': description,
          'goals': goals, // add members
        })
        .then((value) => print("Project Created"))
        .catchError((error) => print("Failed to create project: $error"));
  }
}
