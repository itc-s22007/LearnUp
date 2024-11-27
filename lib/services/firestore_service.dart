import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 学習進捗データを取得するメソッド
  Stream<QuerySnapshot> getStudyProgress(String studentId) {
    return _firestore
        .collection('students') // `students` コレクション
        .doc(studentId) // 学生ごとのドキュメント
        .collection('progress') // `progress` サブコレクション
        .orderBy('timestamp') // 時間順に並べる
        .snapshots();
  }
}
