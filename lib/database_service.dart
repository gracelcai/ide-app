import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ide_app/authentication_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore;

  DatabaseService(this._firebaseFirestore);
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createProject(
      String title, String description, String goals, User user) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members

    QuerySnapshot querySnap =
        await users.where('userid', isEqualTo: user.uid).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;

    Future<void> project = projects
        .add({
          'title': title,
          'description': description,
          'goals': goals, // add members
          'owner': docRef
        })
        .then((value) => (docRef.update({
              // not working
              'projects': FieldValue.arrayUnion([value])
            })))
        .catchError((error) => () {});

    print("Created project");
    return project;
  }
}
