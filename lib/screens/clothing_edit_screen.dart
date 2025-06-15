import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClothingEditScreen extends StatefulWidget {
  final String docId;

  const ClothingEditScreen({required this.docId, super.key});

  @override
  State<ClothingEditScreen> createState() => _ClothingEditScreenState();
}

class _ClothingEditScreenState extends State<ClothingEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _category = '상의';
  bool _isWashed = true;
  String? _imageUrl;
  File? _newImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClothing();
  }

  Future<void> fetchClothing() async {
    final doc = await FirebaseFirestore.instance
        .collection('clothes')
        .doc(widget.docId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    _nameController.text = data['name'] ?? '';
    _category = data['category'] ?? '상의';
    _isWashed = data['isWashed'] ?? true;
    _imageUrl = data['imageUrl'] ?? '';
    setState(() => isLoading = false);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _newImage = File(picked.path));
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('clothes/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('업로드 오류: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl = _imageUrl;
    if (_newImage != null) {
      imageUrl = await _uploadImage(_newImage!);
    }

    final updated = {
      'name': _nameController.text.trim(),
      'category': _category,
      'isWashed': _isWashed,
      'imageUrl': imageUrl ?? '',
    };

    await FirebaseFirestore.instance
        .collection('clothes')
        .doc(widget.docId)
        .update(updated);

    if (mounted) Navigator.pop(context); // 수정 완료 후 뒤로
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('옷 수정하기')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _newImage != null
                    ? Image.file(_newImage!, height: 180, fit: BoxFit.cover)
                    : (_imageUrl != null && _imageUrl!.isNotEmpty)
                    ? Image.network(_imageUrl!, height: 180)
                    : Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Text('이미지 없음')),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '옷 이름'),
                validator: (v) => v == null || v.isEmpty ? '이름 입력' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['상의', '하의', '아우터', '신발', '기타']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
                decoration: const InputDecoration(labelText: '카테고리'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('세탁 완료'),
                value: _isWashed,
                onChanged: (v) => setState(() => _isWashed = v),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
