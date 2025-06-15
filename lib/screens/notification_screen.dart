import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String uid;

  const NotificationScreen({required this.uid, super.key}); // ✅ uid 파라미터 추가

  @override
  Widget build(BuildContext context) {
    final notifications = [
      '오늘 비가 와요. 장우산을 챙기세요!',
      '내일은 맑음 ☀️',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}
