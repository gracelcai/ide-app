import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ide_app/authentication_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService(this._firebaseFirestore);
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  late DocumentReference userRef;

  Future<void> createProject(
      String title, String description, String goals, User user) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members

    QuerySnapshot querySnap =
        await users.where('userid', isEqualTo: user.uid).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    userRef = doc.reference;

    Future<void> project = projects
        .add({
          'title': title,
          'description': description,
          'goals': goals, // add members
          'owner': userRef
        })
        .then((value) => (userRef.update({
              'projects': FieldValue.arrayUnion([value])
            }))) // add to array in user's doc
        .catchError((error) => () {});

    print("Created project");

    return project;
  }

  // Future<DocumentSnapshot<Object?>> getProjects(User user) async {
  //   QuerySnapshot querySnap =
  //       await users.where('userid', isEqualTo: user.uid).get();
  //   QueryDocumentSnapshot doc = querySnap.docs[0];
  //   DocumentReference docRef = doc.reference;
  //   Future<DocumentSnapshot<Object?>> projects = docRef.get();

  //   return projects;
  // }

  Future<String> getUserDocId() async {
    User? user = AuthenticationService(_firebaseAuth).getUser();
    QuerySnapshot querySnap =
        await users.where('userid', isEqualTo: user!.uid).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;
    return docRef.id;
  }

  // Future<void> addTask(String task) async {
  //   Future<void> newTask = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(getUserDocId())
  //       .collection("tasks")
  //       .add({
  //     'task': task,
  //     'complete': false,
  //   });
  //   print("Added task");
  //   return newTask;
  // }
}
