import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 学習進捗を取得する
  Stream<QuerySnapshot> getStudyProgress(String studentId) {
    return _firestore
        .collection('studyProgress')
        .where('studentId', isEqualTo: studentId) // studentId でフィルタリング
        .orderBy('timestamp') // タイムスタンプ順にソート
        .snapshots();
  }

  /// 学習進捗を Firestore に追加
  Future<void> addStudyProgress({
    required String studentId,
    required int score,
    required String taskName,
  }) async {
    try {
      await _firestore.collection('studyProgress').add({
        'studentId': studentId,
        'score': score,
        'taskName': taskName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('学習進捗が保存されました');
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }
}
