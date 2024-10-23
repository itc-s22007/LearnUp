import 'package:flutter/material.dart';

class RewardSystem {
  int points = 0;
  int level = 1;
  List<String> badges = [];

  void addPoints(int score) {
    points += score;
    checkForLevelUp();
    checkForBadges();
  }

  void checkForLevelUp() {
    if (points >= level * 100) {
      level++;
    }
  }

  void checkForBadges() {
    if (points >= 500 && !badges.contains('500ポイント達成')) {
      badges.add('500ポイント達成');
    }
    if (level >= 5 && !badges.contains('レベル5達成')) {
      badges.add('レベル5達成');
    }
  }

  String getCurrentLevel() {
    return '現在のレベル: $level';
  }

  List<String> getBadges() {
    return badges;
  }

  int getPoints() {
    return points;
  }
}
