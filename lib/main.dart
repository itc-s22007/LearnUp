import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnup/unit/school%20year/3rd/InequalitySign.dart';
import 'firebase_options.dart';
import 'home/HomeScreen.dart';
import 'users/loginScreen.dart';


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

      // home: const InequalitySign(format: '',),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
      // home: ProgressScreen(studentId: 'sampleStudentId'),
    );
  }
}

