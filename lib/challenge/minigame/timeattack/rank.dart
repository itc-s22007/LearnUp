import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankScreen extends StatelessWidget {
  final String operation;

  const RankScreen({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    final CollectionReference ranksCollection = FirebaseFirestore.instance
        .collection('ranks')
        .doc(operation)
        .collection('scores');

    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ranksCollection
            .orderBy('score', descending: true)
            .limit(10)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ランキングデータがありません'));
          }

          final ranks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ranks.length,
            itemBuilder: (context, index) {
              final rankData = ranks[index].data() as Map<String, dynamic>;
              final userName = rankData['userName'] ?? '不明なユーザー';
              final score = rankData['score'] as int? ?? 0;

              IconData rankIcon;
              Color rankColor;

              if (index == 0) {
                rankIcon = Icons.star;
                rankColor = Colors.amber;
              } else if (index == 1) {
                rankIcon = Icons.star_border;
                rankColor = Colors.grey;
              } else if (index == 2) {
                rankIcon = Icons.star_border;
                rankColor = Colors.brown;
              } else {
                rankIcon = Icons.star_border;
                rankColor = Colors.black54;
              }

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: rankColor,
                        radius: 25,
                        child: Icon(rankIcon, color: Colors.white),
                      ),
                    ],
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'スコア: $score',
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    '${index + 1}位',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              );
            },
          );
        },
      ),
    );
  }
}