import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealTimeResultScreen extends StatelessWidget {
  final String roomId;
  final bool isHost;

  const RealTimeResultScreen({super.key, required this.roomId, required this.isHost});

  Future<String> _determineWinner() async {
    final roomData = await FirebaseFirestore.instance.collection('battleRooms').doc(roomId).get();

    final player1Progress = roomData['player1']['progress'] ?? 0;
    final player2Progress = roomData['player2']['progress'] ?? 0;

    if (isHost) {
      if (player1Progress > player2Progress) {
        return 'あなたの勝利！';
      } else if (player1Progress < player2Progress) {
        return '相手の勝利！';
      } else {
        return '引き分け！';
      }
    } else {
      if (player2Progress > player1Progress) {
        return 'あなたの勝利！';
      } else if (player2Progress < player1Progress) {
        return '相手の勝利！';
      } else {
        return '引き分け！';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('結果'),
      ),
      body: FutureBuilder<String>(
        future: _determineWinner(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          }

          return Center(
            child: Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
