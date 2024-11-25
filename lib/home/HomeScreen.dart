import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Profile.dart';
import 'LevelScreen.dart';
import '../screens/scoring_screen.dart';
import 'Review.dart';
import 'challenge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String userName = "ユーザー名";
  String userEmail = "example@example.com";

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = doc.data()?['userName'] ?? "ユーザー名";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[500],
        child: Column(
          children: [
            GestureDetector(
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) {
                  _animationController.reverse();
                  Future.delayed(const Duration(milliseconds: 150), () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                    _loadUserDetails();
                  });
                },
                onTapCancel: () => _animationController.reverse(),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
            ),

            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    const Text(
                      '問題',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LevelScreen(onLevelSelected: (selectedLevel) {}),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '成績',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScoringScreen()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.pink,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '復習',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewScreen()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.yellow,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '挑戦',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChallengeScreen()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 17,
                        color: Colors.blue,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'ホーム',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => print("ホームが押されました"),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 85,
                              height: 20,
                              color: Colors.black87,
                              margin: const EdgeInsets.only(left: 10),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                color: Colors.brown,
                                width: 50,
                                height: 30,
                              ),
                            ),
                          ),
                          Align(
                            child: Container(
                              width: 73,
                              height: 7,
                              margin: const EdgeInsets.only(left: 10),
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20)
            ),
          ],
        ),
      ),
    );
  }
}
