import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StylingEditScreen extends StatefulWidget {
  final String stylingId;
  final String uid;

  const StylingEditScreen({required this.stylingId, required this.uid, super.key});

  @override
  State<StylingEditScreen> createState() => _StylingEditScreenState();
}

class _StylingEditScreenState extends State<StylingEditScreen> {
  List<Map<String, dynamic>> allClothes = [];
  List<String> selectedClothes = [];
  String memo = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // 1. 스타일링 데이터
    final stylingDoc = await FirebaseFirestore.instance
        .collection('styling')
        .doc(widget.stylingId)
        .get();

    final stylingData = stylingDoc.data()!;
    selectedClothes = List<String>.from(stylingData['clothes'] ?? []);
    memo = stylingData['memo'] ?? '';

    // 2. 전체 옷 목록
    final clothesSnapshot = await FirebaseFirestore.instance
        .collection('clothes')
        .where('uid', isEqualTo: widget.uid)
        .get();

    allClothes = clothesSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    setState(() => isLoading = false);
  }

  Future<void> saveUpdate() async {
    await FirebaseFirestore.instance
        .collection('styling')
        .doc(widget.stylingId)
        .update({
      'clothes': selectedClothes,
      'memo': memo,
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('코디 수정')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allClothes.length,
              itemBuilder: (context, index) {
                final item = allClothes[index];
                final id = item['id'];
                final isChecked = selectedClothes.contains(id);
                return CheckboxListTile(
                  title: Text(item['name'] ?? '이름 없음'),
                  value: isChecked,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedClothes.add(id);
                      } else {
                        selectedClothes.remove(id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              initialValue: memo,
              onChanged: (value) => memo = value,
              decoration: const InputDecoration(
                labelText: '메모 수정',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: saveUpdate,
            child: const Text('수정 완료'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
