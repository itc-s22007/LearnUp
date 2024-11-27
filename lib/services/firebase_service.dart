import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getStudyProgress(String studentId) {
    return _firestore
        .collection('students')
        .doc(studentId)
        .collection('progress')
        .orderBy('timestamp')
        .snapshots();
  }
}
