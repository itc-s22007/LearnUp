import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/challenge.dart';
import 'WaitingRoomScreen.dart';

class MatchRoomScreen extends StatefulWidget {
  @override
  State<MatchRoomScreen> createState() => _MatchRoomScreenState();
}

class _MatchRoomScreenState extends State<MatchRoomScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final CollectionReference _battleRooms = FirebaseFirestore.instance
      .collection('battleRooms');
  bool _isCreatingRoom = false;

  Future<void> _createRoom() async {
    final String password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('合言葉を入力してください')),
      );
      return;
    }

    setState(() {
      _isCreatingRoom = true;
    });

    await _battleRooms.doc(password).set({
      'questions': [],
      'answers': [],
      'player1': {'score': 0, 'progress': 0},
      'player2': null,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingRoomScreen(roomId: password, isHost: true),
      ),
    );

    setState(() {
      _isCreatingRoom = false;
    });
  }

  Future<void> _joinRoom() async {
    final String password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('合言葉を入力してください')),
      );
      return;
    }

    final room = await _battleRooms.doc(password).get();
    if (!room.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('部屋が存在しません')),
      );
      return;
    }

    await _battleRooms.doc(password).update({
      'player2': {'score': 0, 'progress': 0},
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WaitingRoomScreen(roomId: password, isHost: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              '四則演算対戦',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // テキストとその下の要素の間の余白
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '合言葉を入力',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isCreatingRoom)
                      const CircularProgressIndicator(color: Colors.brown)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            onPressed: _createRoom,
                            child: const Text(
                              '部屋を作成',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            onPressed: _joinRoom,
                            child: const Text(
                              '部屋に参加',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChallengeScreen(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 85,
                          height: 20,
                          color: Colors.black87,
                          margin: const EdgeInsets.only(right: 5),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            color: Colors.brown,
                            width: 50,
                            height: 30,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 73,
                          height: 7,
                          margin: const EdgeInsets.only(right: 10),
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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