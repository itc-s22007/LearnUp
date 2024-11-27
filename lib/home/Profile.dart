import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "ユーザー名";
  String userEmail = "メールアドレス";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists && mounted) {
          setState(() {
            userName = userDoc['userName'] ?? "ユーザー名";
            userEmail = currentUser.email ?? "メールアドレス";
          });
        }
      }
    } catch (e) {
      debugPrint("プロフィールの取得に失敗しました: $e");
    }
  }

  Future<void> _editUserName() async {
    TextEditingController textController = TextEditingController(text: userName);

    String? newUserName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ユーザー名を変更"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: "新しいユーザー名",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(textController.text),
              child: const Text("保存"),
            ),
          ],
        );
      },
    );

    if (newUserName != null && newUserName.isNotEmpty) {
      try {
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .set({'userName': newUserName}, SetOptions(merge: true));

          setState(() {
            userName = newUserName;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ユーザー名を変更しました')),
          );
        }
      } catch (e) {
        debugPrint("ユーザー名の保存に失敗しました: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザー名の保存に失敗しました')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("プロフィール"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
            "ユーザー名",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: _editUserName,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text(
                  "メールアドレス",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const Divider(),
            ListTile(
              title: const Text("成績"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('成績画面へ')),
                );
              },
            ),
            ListTile(
              title: const Text("報酬"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('報酬画面へ')),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("設定"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('設定画面へ')),
                );
              },
            ),
            ListTile(
              title: const Text("ログアウト"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ログアウトしました')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
