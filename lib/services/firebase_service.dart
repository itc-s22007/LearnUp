import 'package:cloud_firestore/cloud_firestore.dart';

void saveProgress(String userId, int score, int studyTime) {
  FirebaseFirestore.instance.collection('users').doc(userId).collection('progress').add({
    'date': Timestamp.now(),
    'score': score,
    'studyTime': studyTime,
  });
}

String generateAdvice(int recentScore, List<int> pastScores) {
  double averageScore = pastScores.reduce((a, b) => a + b) / pastScores.length;

  if (recentScore >= averageScore) {
    return '良いペースで成長しています！この調子で頑張りましょう。';
  } else {
    return '最近の成績が平均を下回っています。復習をしてみましょう！';
  }
}

void showAdvice(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .orderBy('date', descending: true)
      .limit(5)
      .get();

  if (snapshot.docs.isNotEmpty) {
    final pastScores = snapshot.docs.map((doc) => doc.data()['score'] as int).toList();
    final recentScore = pastScores.first;
    final advice = generateAdvice(recentScore, pastScores);
    print(advice);  // アドバイスを表示
  }
}
