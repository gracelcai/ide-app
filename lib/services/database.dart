import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_hacks/models/stat.dart';

class DatabaseService {
  // collection reference
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference statsCollection =
      Firestore.instance.collection('stats');
  Future updateUserData(String name, String gender, String feet, String inches,
      String weight, String age, String exercise) async {
    return await statsCollection.document(uid).setData({
      'name': name,
      'gender': gender,
      'feet': feet,
      'inches': inches,
      'weight': weight,
      'age': age,
      'exercise': exercise,
    });
  }

  // stats list from snapshot
  List<Stat> _statsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Stat(
          name: doc.data['name'] ?? '',
          gender: doc.data['gender'] ?? '',
          feet: doc.data['feet'] ?? '',
          inches: doc.data['inches'] ?? '',
          weight: doc.data['weight'] ?? '',
          age: doc.data['age'] ?? '',
          exercise: doc.data['exercise'] ?? ''
      );
    }).toList();
  }

  Stream<List<Stat>> get stats {
    return statsCollection.snapshots().map(_statsListFromSnapshot);

  }
}
