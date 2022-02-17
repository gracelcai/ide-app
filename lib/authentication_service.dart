import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  // 1
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // 2
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // 3
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

  // 4
  Future<String?> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      users
          .add({
            'name': name,
            'email': email,
          })
          .then((value) => print("$value User Added"))
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
}
