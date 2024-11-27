import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/progress_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnUp Progress Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProgressScreen(studentId: 'sampleStudentId'), // ここで学生IDを設定
    );
  }
}
