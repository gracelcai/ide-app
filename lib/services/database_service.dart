import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ide_app/services/authentication_service.dart';

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
          'owner': userRef,
          'roles': {
            userRef.id: 'owner',
          },
        })
        .then((value) => (userRef.update({
              'projects': FieldValue.arrayUnion([value])
            }))) // add to array in user's doc
        .catchError((error) => () {});

    print("Created project");

    return project;
  }

  Future<void> addProjectMembers(String projectId, String email) async {
    String userDoc = await getUserFromEmail(email);
    String userId = await getUserIdFromDoc(userDoc);
    DocumentReference project =
        FirebaseFirestore.instance.collection("projects").doc(projectId);
    DocumentReference newMember =
        FirebaseFirestore.instance.collection("users").doc(userDoc);
    project.update({
      'roles': FieldValue.arrayUnion([
        {userDoc: "editor"}
      ])
    });

    newMember.update({
      'projects': FieldValue.arrayUnion([project])
    });
    print("added $email");
  }

  // Future<DocumentSnapshot<Object?>> getProjects(User user) async {
  //   QuerySnapshot querySnap =
  //       await users.where('userid', isEqualTo: user.uid).get();
  //   QueryDocumentSnapshot doc = querySnap.docs[0];
  //   DocumentReference docRef = doc.reference;
  //   Future<DocumentSnapshot<Object?>> projects = docRef.get();

  //   return projects;
  // }

  /// Gets user document id from current user id
  Future<String> getUserDocId() async {
    User? user = AuthenticationService(_firebaseAuth).getUser();
    QuerySnapshot querySnap =
        await users.where('userid', isEqualTo: user!.uid).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;
    return docRef.id;
  }

  ///Gets user document id from user id
  Future<String> getUserDocFromId(String id) async {
    User? user = AuthenticationService(_firebaseAuth).getUser();
    QuerySnapshot querySnap = await users.where('userid', isEqualTo: id).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;
    return docRef.id;
  }

  /// Gets user document id using email
  Future<String> getUserFromEmail(String email) async {
    QuerySnapshot querySnap =
        await users.where('email', isEqualTo: email).get();
    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = querySnap.docs[0];
      DocumentReference docRef = doc.reference;
      return docRef.id;
    } else {
      return "invalid";
    }
  }

  Future<String> getUserIdFromDoc(String id) async {
    print(id);
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    final data = doc.data() as Map<String, dynamic>;
    return data["userid"];
  }

  Future<void> addTask(String task) async {
    print(await getUserDocId());
    Future<void> newTask = FirebaseFirestore.instance
        .collection('users')
        .doc(await getUserDocId())
        .collection('tasks')
        .add({
      'task': task,
      'complete': false,
    });
    print("Added task");
    return newTask;
  }
}
