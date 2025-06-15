import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StylingAddScreen extends StatefulWidget {
  final String uid;

  const StylingAddScreen({required this.uid, super.key});

  @override
  State<StylingAddScreen> createState() => _StylingAddScreenState();
}

class _StylingAddScreenState extends State<StylingAddScreen> {
  List<String> selectedClothes = [];
  String memo = '';
  bool isLoading = true;
  List<Map<String, dynamic>> allClothes = [];

  @override
  void initState() {
    super.initState();
    fetchClothes();
  }

  Future<void> fetchClothes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('clothes')
        .where('uid', isEqualTo: widget.uid)
        .get();

    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // 문서 ID 포함
      return data;
    }).toList();

    setState(() {
      allClothes = items;
      isLoading = false;
    });
  }

  Future<void> saveStyling() async {
    if (selectedClothes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('하나 이상의 옷을 선택하세요')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('styling').add({
      'uid': widget.uid,
      'clothes': selectedClothes,
      'memo': memo,
      'createdAt': DateTime.now().toIso8601String(),
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎨 코디 추가')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allClothes.length,
              itemBuilder: (context, index) {
                final item = allClothes[index];
                final id = item['id'];
                final name = item['name'] ?? '이름 없음';

                final isSelected = selectedClothes.contains(id);

                return CheckboxListTile(
                  title: Text(name),
                  value: isSelected,
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
            child: TextField(
              onChanged: (value) => memo = value,
              decoration: const InputDecoration(
                labelText: '코디 메모 (선택)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: saveStyling,
            child: const Text('저장'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
