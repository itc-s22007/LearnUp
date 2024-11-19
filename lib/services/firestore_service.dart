import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 学生の学習進捗を取得するメソッド
  Stream<QuerySnapshot> getStudyProgress(String studentId) {
    try {
      return _firestore
          .collection('students') // `students` コレクション
          .doc(studentId) // 学生ごとのドキュメント
          .collection('progress') // 進捗データのサブコレクション
          .orderBy('timestamp') // 時間順に並び替え
          .snapshots();


    } catch (e) {
      print('Error fetching study progress: $e');
      return const Stream.empty();
    }
  }
}
