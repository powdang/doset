import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'clothing_add_screen.dart';
import 'clothing_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  final String uid;

  const WardrobeScreen({required this.uid, super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  bool? _washedFilter;
  String _categoryFilter = '전체';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final baseQuery = FirebaseFirestore.instance
        .collection('clothes')
        .where('uid', isEqualTo: widget.uid);

    Query filteredQuery = baseQuery;

    if (_washedFilter != null) {
      filteredQuery = filteredQuery.where('isWashed', isEqualTo: _washedFilter);
    }

    if (_categoryFilter != '전체') {
      filteredQuery = filteredQuery.where('category', isEqualTo: _categoryFilter);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('내 옷장')),
      body: Column(
        children: [
          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value.trim()),
              decoration: const InputDecoration(
                labelText: '옷 이름 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 🔘 필터
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Text('세탁 필터: '),
                DropdownButton<bool?>(
                  value: _washedFilter,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('전체')),
                    DropdownMenuItem(value: true, child: Text('세탁됨')),
                    DropdownMenuItem(value: false, child: Text('미세탁')),
                  ],
                  onChanged: (v) => setState(() => _washedFilter = v),
                ),
                const SizedBox(width: 20),
                const Text('카테고리: '),
                DropdownButton<String>(
                  value: _categoryFilter,
                  items: ['전체', '상의', '하의', '아우터', '신발', '기타']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoryFilter = v!),
                ),
              ],
            ),
          ),

          // 📃 옷 리스트
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: filteredQuery.orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final clothes = snapshot.data!.docs;

                final filteredClothes = clothes.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name']?.toString().toLowerCase() ?? '';
                  return name.contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredClothes.isEmpty) {
                  return const Center(child: Text('조건에 맞는 옷이 없습니다.'));
                }

                return ListView.builder(
                  itemCount: filteredClothes.length,
                  itemBuilder: (context, index) {
                    final item = filteredClothes[index].data() as Map<String, dynamic>;
                    final imageUrl = item['imageUrl'] ?? '';

                    return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 25)
                          : const CircleAvatar(child: Icon(Icons.image_not_supported)),
                      title: Text(item['name'] ?? '이름 없음'),
                      subtitle: Text(
                        '카테고리: ${item['category']}, '
                            '세탁됨: ${item['isWashed'] == true ? '예' : '아니오'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('clothes')
                              .doc(filteredClothes[index].id)
                              .delete();
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClothingDetailScreen(docId: filteredClothes[index].id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ 옷 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClothingAddScreen(uid: widget.uid),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: '옷 추가',
      ),
    );
  }
}
