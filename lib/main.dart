import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnup/users/loginScreen.dart';
import 'firebase_options.dart';
import 'home/HomeScreen.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''), // 日本語
        Locale('en', ''), // 英語
      ],
      locale: const Locale('ja', ''), // アプリ全体を日本語に設定
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
      // home: ProgressScreen(studentId: 'sampleStudentId'),
    );
  }
}
