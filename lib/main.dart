import 'package:flutter/material.dart';
import 'login/Login.dart'; // 既存のログイン画面
import 'register_screen.dart';


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
      home: const LoginScreen(), // 初期画面はログイン画面
    );
  }
}

// 新規登録画面のコードを追加
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              String email = emailController.text;
              String password = passwordController.text;
              print('Email: $email, Password: $password');
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ログイン画面に戻る
            },
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}
