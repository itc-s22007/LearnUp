import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AdviceSection extends StatelessWidget {
  final String studentId;
  final FirestoreService _firestoreService = FirestoreService();

  AdviceSection({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _firestoreService.getAdvice(studentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Text(
          'アドバイス: ${snapshot.data}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
