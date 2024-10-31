import 'package:flutter/material.dart';

import '../home/Profile.dart';
import 'LevelScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _AllLevelScreenState();
}

class _AllLevelScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> items = [
    {'color': Colors.orange, 'text': '問題集'},
    {'color': Colors.purple, 'text': 'タイムアタック'},
    {'color': Colors.green, 'text': '全画面'},
    {'color': Colors.teal, 'text': '復習'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ホーム"),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: currentIndex == 0
              ? LevelScreen(isChoice: null, onLevelSelected: (selectedLevel) {  },)
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  items[currentIndex]['text'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: '',
        child: const Icon(Icons.article),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7.0,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.book),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.timer),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


