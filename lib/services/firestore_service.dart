import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStudyRecord(String studentId, DateTime date, int score, int studyTime) async {
    await _firestore.collection('students').doc(studentId).collection('progress').add({
      'date': date,
      'score': score,
      'studyTime': studyTime,
    });
  }

  Stream<QuerySnapshot> getStudyProgress(String studentId) {
    return _firestore.collection('students').doc(studentId).collection('progress').orderBy('date').snapshots();
  }

  Future<String> getAdvice(String studentId) async {
    DocumentSnapshot doc = await _firestore.collection('students').doc(studentId).get();
    return doc['advice']['adviceText'] ?? 'アドバイスはまだありません';
  }
}
