import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClothingAddScreen extends StatefulWidget {
  final String uid;

  const ClothingAddScreen({required this.uid, super.key});

  @override
  State<ClothingAddScreen> createState() => _ClothingAddScreenState();
}

class _ClothingAddScreenState extends State<ClothingAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _category = '상의';
  bool _isWashed = true;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref('clothes/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('❌ 이미지 업로드 실패: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImage(_image!);
    }

    final newItem = {
      'uid': widget.uid,
      'name': _nameController.text.trim(),
      'category': _category,
      'isWashed': _isWashed,
      'imageUrl': imageUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('clothes').add(newItem);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👕 옷 등록')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? Image.file(_image!, height: 180, fit: BoxFit.cover)
                    : Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: Text('이미지 선택')),
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
                child: const Text('등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
