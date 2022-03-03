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
      String title, String description, String goals, String uid) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members
    QuerySnapshot querySnap = await users.where('userid', isEqualTo: uid).get();
    print("uid: " + uid);
    print(querySnap.docs.length);
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.

    DocumentReference docRef = doc.reference;
// await docRef.update(...);
    return projects
        .add({
          'title': title,
          'description': description,
          'goals': goals, // add members
          'owner': docRef
        })
        .then((value) => print("Project Created"))
        .catchError((error) => print("Failed to create project: $error"));
  }
}
