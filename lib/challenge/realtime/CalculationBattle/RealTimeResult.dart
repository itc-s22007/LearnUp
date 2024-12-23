import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealTimeResultScreen extends StatelessWidget {
  final String roomId;
  final bool isHost;

  const RealTimeResultScreen({super.key, required this.roomId, required this.isHost});

  @override
  Widget build(BuildContext context) {
    final battleRoom = FirebaseFirestore.instance.collection('battleRooms');
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // 上部の余白
            const Text(
              '対戦結果',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: battleRoom.doc(roomId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('エラーが発生しました。', style: TextStyle(color: Colors.white)));
                  }

                  final data = snapshot.data?.data() as Map<String, dynamic>?;
                  if (data == null) {
                    return const Center(child: Text('データがありません。', style: TextStyle(color: Colors.white)));
                  }

                  final player1Progress = data['player1']?['progress'] ?? 0;
                  final player2Progress = data['player2']?['progress'] ?? 0;

                  // 勝者の判定
                  String winnerMessage;
                  if (player1Progress >= 20 && player2Progress >= 20) {
                    winnerMessage = '引き分けです！';
                  } else if (player1Progress >= 20) {
                    winnerMessage = isHost ? 'あなたの勝ち！' : '相手の勝ち！';
                  } else if (player2Progress >= 20) {
                    winnerMessage = isHost ? '相手の勝ち！' : 'あなたの勝ち！';
                  } else {
                    winnerMessage = 'ゲームは終了していません。';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          winnerMessage,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '戻る',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              color: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }
}
