import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RealTimeBattleScreen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final String roomId;
  final bool isHost;

  const WaitingRoomScreen({super.key, required this.roomId, required this.isHost});

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  late CollectionReference _battleRooms;
  late Stream<DocumentSnapshot> _roomStream;
  bool isMatched = false; // マッチング状態を追跡

  @override
  void initState() {
    super.initState();
    _battleRooms = FirebaseFirestore.instance.collection('battleRooms');
    _roomStream = _battleRooms.doc(widget.roomId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('待機中')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _roomStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final player2 = data['player2'];
          final currentPlayers = player2 != null ? 2 : 1;

          // マッチングした場合の処理
          if (currentPlayers == 2 && !isMatched) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isMatched = true; // マッチングした状態にする
              });

              // マッチング後にダイアログを表示
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'マッチングしました！',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '試合を開始します。',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              );

              // 1秒後に試合画面に遷移
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealTimeBattleScreen(
                      roomId: widget.roomId,
                      isHost: widget.isHost,
                    ),
                  ),
                );
              });
            });
          }

          // プレイヤーがまだ2人集まっていない場合
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '相手を探しています...',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  '$currentPlayers/2',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (widget.isHost)
                  const Text(
                    '合言葉を共有してください',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}