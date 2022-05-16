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
          'owner': userRef, //members list
          'members': [userRef], // takes user doc refs
        })
        .then((value) => (userRef.update({
              'projects': FieldValue.arrayUnion([value])
            }))) // add to array in user's doc
        .catchError((error) => () {});

    return project;
  }

  Future<void> updateProject(
      String id, String title, String description, String goals) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members

    Future<void> project = projects.doc(id).update({
      'title': title,
      'description': description,
      'goals': goals, // add members
    }).catchError((error) => () {});
    return project;
  }

  Future<void> updateLink(String projectId, String linkId, String name,
      String description, String link) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members

    Future<void> project =
        projects.doc(projectId).collection('links').doc(linkId).update({
      'name': name,
      'description': description,
      'link': link, // add members
    }).catchError((error) => () {});
    return project;
  }

  Future<void> addProjectMembers(String projectId, String email) async {
    String userId = await getUserFromEmail(email);

    DocumentReference project =
        FirebaseFirestore.instance.collection("projects").doc(projectId);
    DocumentReference newMember =
        FirebaseFirestore.instance.collection("users").doc(userId);
    project.update({
      'members': FieldValue.arrayUnion([newMember])
    });

    newMember.update({
      'projects': FieldValue.arrayUnion([project])
    });
    print("added $email");
  }

  Future<void> createLink(
      String name, String description, String link, String projectId) async {
    // Call the user's CollectionReference to add a new user
    // array of references user's projects in user document
    // projects in separate collection with array of references to members

    CollectionReference links = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectId)
        .collection("links");
    links.add({
      'name': name,
      'description': description,
      'link': link,
    });
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

  Future<String> getUserId() async {
    return AuthenticationService(_firebaseAuth).getUser()!.uid;
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

  Future<void> addTask(
      String task, bool complete, String day, String month) async {
    //print(await getUserDocId());
    Future<void> newTask = FirebaseFirestore.instance
        .collection('users')
        .doc(await getUserDocId())
        .collection('tasks')
        .add({
      'task': task,
      'complete': complete,
      'day': int.parse(day),
      'month': int.parse(month),
    });
    print("Added task");
    return newTask;
  }

  Future<void> toggleTask(String taskID, bool completed) async {
    Future<void> newTask = FirebaseFirestore.instance
        .collection('users')
        .doc(await getUserDocId())
        .collection('tasks')
        .doc(taskID)
        .update({
      'complete': completed,
    });
  }
}
