import 'package:flutter/material.dart';

import 'clothing_add_screen.dart';

class ClothingScreen extends StatelessWidget {
  final String uid;

  const ClothingScreen({required this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 옷장')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('여기에 사용자의 옷 목록을 표시합니다.'),
            Text('UID: $uid'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClothingAddScreen(uid: uid),
                  ),
                );
              },
              child: const Text('👕 옷 추가하기'),
            ),

          ],
        ),
      ),
    );
  }
}
