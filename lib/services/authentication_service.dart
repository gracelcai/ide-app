import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  // 1
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // 2
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  late Future<void> userDoc;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      UserCredential userCred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userCred.user!.updateDisplayName(name);
      List<DocumentReference> projects = [];
      userDoc = users
          .doc(userCred.user!.uid)
          .set({
            'name': name,
            'email': email,
            'userid': userCred.user!.uid,
            'projects': projects
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 5
  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// 6
  User? getUser() {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<DocumentReference<Object?>> getUserDoc() async {
    User? user = _firebaseAuth.currentUser;
    // QuerySnapshot querySnap =
    //     await users.where('userid', isEqualTo: user!.uid).get();
    // QueryDocumentSnapshot doc = querySnap.docs[0];
    // DocumentReference userDoc = doc.reference;
    // return userDoc;
    return FirebaseFirestore.instance.collection("users").doc(user!.uid);
  }
}
