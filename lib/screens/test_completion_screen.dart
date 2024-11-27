import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class TestCompletionScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final String studentId = 'sampleStudentId'; // 学生ID（本来はログイン情報などから取得）

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テスト結果'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 学習データを記録する
            await _firestoreService.addStudyProgress(
              studentId: studentId,
              score: 85, // 実際のスコアをここに入れる
              taskName: '掛け算の練習', // 学習タスク名を入れる
            );

            // 確認メッセージを表示
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('データが記録されました！')),
            );
          },
          child: const Text('データを記録'),
        ),
      ),
    );
  }
}
