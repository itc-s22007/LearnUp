import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RealTimeResultScreen extends StatelessWidget {
  final String roomId;
  final bool isHost;

  const RealTimeResultScreen({super.key, required this.roomId, required this.isHost});

  @override
  Widget build(BuildContext context) {
    final battleRoom = FirebaseFirestore.instance.collection('battleRooms');
    return Scaffold(
      appBar: AppBar(
        title: const Text('対戦結果'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: battleRoom.doc(roomId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました。'));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Center(child: Text('データがありません。'));
          }

          final player1Progress = data['player1']?['progress'] ?? 0;
          final player2Progress = data['player2']?['progress'] ?? 0;

          // 勝者の判定
          String winnerMessage;
          String opponentMessage;
          if (player1Progress >= 20 && player2Progress >= 20) {
            winnerMessage = '引き分けです！';
            opponentMessage = '';
          } else if (player1Progress >= 20) {
            winnerMessage = isHost ? 'あなたの勝ち！' : '相手の勝ち！';
            opponentMessage = isHost ? '相手の勝ち！' : 'あなたの勝ち！';
          } else if (player2Progress >= 20) {
            winnerMessage = isHost ? '相手の勝ち！' : 'あなたの勝ち！';
            opponentMessage = isHost ? 'あなたの勝ち！' : '相手の勝ち！';
          } else {
            winnerMessage = 'ゲームは終了していません。';
            opponentMessage = '';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  winnerMessage,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                if (opponentMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      opponentMessage,
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 戻るボタン
                  },
                  child: const Text('戻る'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
