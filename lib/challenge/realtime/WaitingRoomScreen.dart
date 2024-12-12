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

          if (currentPlayers == 2) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  int countdown = 3;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (countdown > 1) {
                          setState(() => countdown--);
                        } else {
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
                        }
                      });
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '試合開始までお待ちください',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '$countdown',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            });
          }

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