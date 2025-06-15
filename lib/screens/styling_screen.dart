import 'package:doset/screens/styling_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StylingScreen extends StatelessWidget {
  final String uid;

  const StylingScreen({required this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 코디 모음')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('styling')
            .where('uid', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('등록된 코디가 없습니다.'));
          }

          final stylings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: stylings.length,
            itemBuilder: (context, index) {
              final data = stylings[index].data() as Map<String, dynamic>;
              final clothes = (data['clothes'] as List<dynamic>).length;
              final memo = data['memo'] ?? '';
              final date = data['createdAt'] ?? '';

              return ListTile(
                leading: const Icon(Icons.style),
                title: Text('옷 ${clothes}개 조합'),
                subtitle: Text(memo.isNotEmpty ? memo : '메모 없음'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('styling')
                        .doc(stylings[index].id)
                        .delete();
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StylingDetailScreen(stylingId: stylings[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
