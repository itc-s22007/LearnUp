import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  final DateTime date = timestamp.toDate();
  return DateFormat('yyyy/MM/dd HH:mm:ss').format(date); // フォーマットを指定
}
