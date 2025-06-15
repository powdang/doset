import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'clothing_edit_screen.dart';

class ClothingDetailScreen extends StatefulWidget {
  final String docId;

  const ClothingDetailScreen({required this.docId, super.key});

  @override
  State<ClothingDetailScreen> createState() => _ClothingDetailScreenState();
}

class _ClothingDetailScreenState extends State<ClothingDetailScreen> {
  Map<String, dynamic>? clothingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClothingDetail();
  }

  Future<void> fetchClothingDetail() async {
    final doc = await FirebaseFirestore.instance
        .collection('clothes')
        .doc(widget.docId)
        .get();

    if (doc.exists) {
      setState(() {
        clothingData = doc.data();
        isLoading = false;
      });
    }
  }

  Future<void> deleteClothing() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('이 옷을 정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('clothes')
          .doc(widget.docId)
          .delete();

      if (mounted) Navigator.pop(context); // 삭제 후 목록으로
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || clothingData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final imageUrl = clothingData!['imageUrl'] ?? '';
    final name = clothingData!['name'] ?? '';
    final category = clothingData!['category'] ?? '';
    final isWashed = clothingData!['isWashed'] == true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('옷 상세 보기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteClothing,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 200, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 150, color: Colors.grey),
            const SizedBox(height: 20),
            ListTile(
              title: Text('이름'),
              subtitle: Text(name),
            ),
            ListTile(
              title: Text('카테고리'),
              subtitle: Text(category),
            ),
            ListTile(
              title: Text('세탁 여부'),
              subtitle: Text(isWashed ? '예' : '아니오'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClothingEditScreen(docId: widget.docId),
                  ),
                );
              },
              child: const Text('수정하기'),
            ),

          ],
        ),
      ),
    );
  }
}
