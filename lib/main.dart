import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnup/users/loginScreen.dart';
import 'firebase_options.dart';
import 'home/HomeScreen.dart';
import 'package:audioplayers/audioplayers.dart';

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
        Locale('ja', ''),
        Locale('en', ''),
      ],
      locale: const Locale('ja', ''),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
      // home: ProgressScreen(studentId: 'sampleStudentId'),
    );
  }
}

class AudioTestWidget extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('assets/sounds/mp3/correct.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: _playSound,
          child: Text('Play Correct Sound'),
        ),
      ),
    );
  }
}
