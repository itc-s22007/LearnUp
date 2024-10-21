import 'package:flutter/material.dart';
import '../format/FormatScreen.dart';
import '../screens/results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> items = [
    {'color': Colors.orange, 'text': '問題集', 'screen': const FormatScreen(problems: [],)},
    {'color': Colors.purple, 'text': 'タイムアタック'},
    {'color': Colors.teal, 'text': '復習'},
    {'color': Colors.brown, 'text': '成績', 'screen': const ResultsScreen(totalQuestions: 10, correctAnswers: 0, questionResults: [],)},
    {'color': Colors.pink, 'text': '報酬'},
  ];

  void _navigateToNextScreen() {
    final screen = items[currentIndex]['screen'];
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('この項目には現在対応する画面がありません。')),
      );
    }
  }

  void _changeIndex(int delta) {
    setState(() {
      currentIndex = (currentIndex + delta + items.length) % items.length;
    });
    _pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('メニュー', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ...items.map((item) => ListTile(
              title: Text(item['text']),
              onTap: () {
                Navigator.pop(context);
                final screen = item['screen'];
                if (screen != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('この項目には現在対応する画面がありません。')),
                  );
                }
              },
            )),
          ],
        ),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _changeIndex(-1),
              child: const Text('<', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 300,
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: items[index]['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        items[index]['text'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => _changeIndex(1),
              child: const Text('>', style: TextStyle(fontSize: 32)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNextScreen,
        tooltip: '決定',
        child: const Icon(Icons.check),
      ),
    );
  }
}


