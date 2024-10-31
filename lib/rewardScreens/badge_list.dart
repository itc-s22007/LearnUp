import 'package:flutter/material.dart';

class BadgeList extends StatelessWidget {
  final List<String> badges;

  BadgeList({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '取得したバッジ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(badges[index]),
            );
          },
        ),
      ],
    );
  }
}
