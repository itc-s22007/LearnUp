import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'WaitingRoomScreen.dart';

class MatchRoomScreen extends StatefulWidget {
  @override
  State<MatchRoomScreen> createState() => _MatchRoomScreenState();
}

class _MatchRoomScreenState extends State<MatchRoomScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final CollectionReference _battleRooms = FirebaseFirestore.instance.collection('battleRooms');
  bool _isCreatingRoom = false;

  Future<void> _createRoom() async {
    final String password = _passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('合言葉を入力してください')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('合言葉を入力してください')));
      return;
    }

    final room = await _battleRooms.doc(password).get();
    if (!room.exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('部屋が存在しません')));
      return;
    }

    await _battleRooms.doc(password).update({
      'player2': {'score': 0, 'progress': 0},
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingRoomScreen(roomId: password, isHost: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プライベートマッチ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '合言葉を入力',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_isCreatingRoom)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _createRoom,
                    child: const Text('部屋を作成'),
                  ),
                  ElevatedButton(
                    onPressed: _joinRoom,
                    child: const Text('部屋に参加'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
