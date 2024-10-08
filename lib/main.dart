import 'package:flutter/material.dart';
import 'login/Login.dart'; // 既存のログイン画面
import 'register_screen.dart';
import 'screens/title_screen.dart'; // タイトル画面

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Register Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TitleScreen(), // 最初の画面をタイトル画面に変更
    );
  }
}
