import 'package:doset/screens/styling_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StylingDetailScreen extends StatefulWidget {
  final String stylingId;

  const StylingDetailScreen({required this.stylingId, super.key});

  @override
  State<StylingDetailScreen> createState() => _StylingDetailScreenState();
}

class _StylingDetailScreenState extends State<StylingDetailScreen> {
  Map<String, dynamic>? stylingData;
  List<Map<String, dynamic>> clothesDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStylingDetail();
  }

  Future<void> fetchStylingDetail() async {
    final stylingDoc = await FirebaseFirestore.instance
        .collection('styling')
        .doc(widget.stylingId)
        .get();

    if (!stylingDoc.exists) return;

    final data = stylingDoc.data()!;
    stylingData = data;

    final clothesIds = List<String>.from(data['clothes'] ?? []);

    for (final id in clothesIds) {
      final doc = await FirebaseFirestore.instance
          .collection('clothes')
          .doc(id)
          .get();

      if (doc.exists) {
        final info = doc.data()!;
        info['id'] = doc.id;
        clothesDetails.add(info);
      }
    }

    setState(() => isLoading = false);
  }

  Future<void> deleteStyling() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('삭제 확인'),
        content: const Text('이 코디를 정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('styling')
          .doc(widget.stylingId)
          .delete();

      if (mounted) Navigator.pop(context); // 삭제 후 이전 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('코디 상세 보기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteStyling,
            tooltip: '삭제',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📝 메모: ${stylingData?['memo'] ?? '없음'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('📅 날짜: ${stylingData?['createdAt'] ?? '알 수 없음'}'),
            const Divider(height: 32),

            const Text('👕 포함된 옷 목록:',
                style: TextStyle(fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: clothesDetails.length,
                itemBuilder: (context, index) {
                  final item = clothesDetails[index];
                  return ListTile(
                    leading: const Icon(Icons.checkroom),
                    title: Text(item['name'] ?? '이름 없음'),
                    subtitle: Text('카테고리: ${item['category']}, '
                        '세탁됨: ${item['isWashed'] == true ? '예' : '아니오'}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StylingEditScreen(
                      stylingId: widget.stylingId,
                      uid: stylingData?['uid'], // 👈 반드시 Firestore에 'uid'가 저장되어 있어야 함
                    ),
                  ),
                );
              },
              child: const Text('✏️ 수정하기'),
            ),
          ],
        ),
      ),
    );
  }
}
