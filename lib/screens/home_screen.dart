import 'package:doset/screens/wardrobe_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'daily_screen.dart';
import 'notification_screen.dart';
import 'weather_screen.dart';
import 'clothing_screen.dart';       // 옷장 화면
import 'styling_screen.dart';       // 코디 화면

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({required this.uid, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    setState(() {
      userId = doc.data()?['userId'] ?? '사용자';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('doset 홈')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('환영합니다, $userId 님 👋', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DailyScreen(uid: widget.uid)),
              ),
              child: const Text('📆 데일리 기록'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationScreen(uid: widget.uid)),
              ),
              child: const Text('🔔 알림'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeatherScreen()),
              ),
              child: const Text('🌦 날씨'),
            ),

            // ✅ 추가된 버튼들
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WardrobeScreen(uid: widget.uid)),
              ),
              child: const Text('👕 내 옷장'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StylingScreen(uid: widget.uid)),
              ),
              child: const Text('🎨 코디 보기'),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('🚪 로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
