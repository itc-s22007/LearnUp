import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../screens/progress_screen.dart';
import 'Profile.dart';
import 'LevelScreen.dart';
import 'review/Review.dart';
import 'challenge.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String userName = "ユーザー名";
  Set<DateTime> completedDays = {};
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int challengeCount = 0;
  int dailyGoal = 5; // デフォルト目標回数

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _resetChallengeIfNeeded();
    _loadChallengeCount();
    _loadDailyGoal();
    _calendarFormat = CalendarFormat.month;
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadCompletedDays();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
  }

  Future<void> _resetChallengeIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final Map<String, dynamic>? userData = doc.data();

      if (userData != null) {
        final String? lastResetDateStr = userData['lastResetDate'];
        final lastResetDate = lastResetDateStr != null ? DateTime.parse(lastResetDateStr) : null;
        final today = DateTime.now();

        if (lastResetDate == null || !isSameDay(lastResetDate, today)) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'challengeCount': 0,
            'lastResetDate': DateFormat('yyyy-MM-dd').format(today),
          });

          setState(() {
            challengeCount = 0;
          });
        }
      }
    }
  }


  Future<void> _loadChallengeCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        challengeCount = doc.data()?['challengeCount'] ?? 0;
      });
    }
  }

  Future<void> _loadDailyGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        dailyGoal = doc.data()?['dailyGoal'] ?? 5;
      });
    }
  }

  Future<void> _loadCompletedDays() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('completedGoals')
          .get();
      setState(() {
        completedDays = doc.docs
            .map((doc) => DateTime.parse(doc['date']))
            .toSet();
        completedDays.add(DateTime.now());
      });
    }
  }

  Future<void> _saveCompletedDay(DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('completedGoals')
          .doc(formattedDate)
          .set({'date': formattedDate});
      setState(() {
        completedDays.add(date);
      });
    }
  }

  bool _isDayCompleted(DateTime day) {
    return completedDays.any((completedDay) => isSameDay(completedDay, day));
  }

  void _onDailyGoalAchieved() async {
    final today = DateTime.now();
    await _saveCompletedDay(today);
  }


  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "カレンダー",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            locale: 'ja_JP',
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (_isDayCompleted(day)) {
                  // 目標達成状態を判定してチェックマークの色を切り替え
                  bool isGoalAchieved = day.year == DateTime.now().year &&
                      day.month == DateTime.now().month &&
                      day.day == DateTime.now().day &&
                      challengeCount >= dailyGoal;

                  return Icon(
                    Icons.check_circle,
                    color: isGoalAchieved ? Colors.red : Colors.green,
                    size: 18,
                  );
                }
                return null;
              },
            ),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
        ],
      ),
    );
  }


  Future<void> _loadUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(
          user.uid).get();
      setState(() {
        userName = doc.data()?['userName'] ?? "ユーザー名";
      });
    }
  }
  Widget _buildDailyGoals() {
    bool _isGoalAchieved = challengeCount >= 5;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "今日の目標",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "現在の挑戦回数: $challengeCount 回",
                style: const TextStyle(fontSize: 16),
              ),
              if (_isGoalAchieved)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "問題モードで5個の単元に挑戦する",
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                _isGoalAchieved ? Icons.check_circle : Icons.circle_outlined,
                color: _isGoalAchieved ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ホーム"),
        backgroundColor: Colors.green[500],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()),
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
                      ),
                    ),
                    _buildDailyGoals(),
                    _buildCalendar(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.brown,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuColumn('問題', Colors.white, LevelScreen(onLevelSelected: (selectedLevel) {})),
                _buildMenuColumn('成績', Colors.pink, ProgressScreen()),
                _buildMenuColumn('復習', Colors.yellow, ReviewScreen()),
                _buildMenuColumn('挑戦', Colors.blue, const ChallengeScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenuColumn(String title, Color color, Widget screen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Container(
            width: 80,
            height: 30,
            color: color,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green[500]),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ??
                        "メールアドレス未設定",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('ホーム'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('プロフィール'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('成績'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProgressScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}