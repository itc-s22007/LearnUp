import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // FlutterFire CLIで生成されたファイルをインポート
import 'login/Login.dart'; // ログイン画面のインポート

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterエンジンの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebaseの初期化
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // ログイン画面をホーム画面に設定
    );
  }
}
