import 'package:cloud_firestore/cloud_firestore.dart';

class RewardSystem {
  int points = 0;
  int level = 1;
  List<String> badges = [];

  RewardSystem();

  // ポイントを追加
  void addPoints(int score) {
    points += score;
    checkForLevelUp();
    checkForBadges();
    saveData();
  }

  // レベルアップを確認
  void checkForLevelUp() {
    if (points >= level * 100) {
      level++;
    }
  }

  // バッジ取得の条件を確認
  void checkForBadges() {
    if (points >= 500 && !badges.contains('500ポイント達成')) {
      badges.add('500ポイント達成');
    }
    if (level >= 5 && !badges.contains('レベル5達成')) {
      badges.add('レベル5達成');
    }
  }

  // ポイントの取得
  int getPoints() {
    return points;
  }

  // 現在のレベルを取得
  String getCurrentLevel() {
    return '現在のレベル: $level';
  }

  // 取得したバッジのリストを返す
  List<String> getBadges() {
    return badges;
  }

  // Firebaseにデータを保存するメソッド
  Future<void> saveData() async {
    await FirebaseFirestore.instance.collection('rewards').doc('user1').set({
      'points': points,
      'level': level,
      'badges': badges,
    });
  }

  // Firebaseからデータを読み込むメソッド
  Future<void> loadData() async {
    final snapshot = await FirebaseFirestore.instance.collection('rewards').doc('user1').get();
    if (snapshot.exists) {
      final data = snapshot.data();
      points = data?['points'] ?? 0;
      level = data?['level'] ?? 1;
      badges = List<String>.from(data?['badges'] ?? []);
    }
  }
}
