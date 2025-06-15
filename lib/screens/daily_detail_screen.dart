import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/daily_record_model.dart';
import '../providers/daily_record_provider.dart';

class DailyDetailScreen extends StatefulWidget {
  final String uid;
  const DailyDetailScreen({required this.uid, super.key});

  @override
  State<DailyDetailScreen> createState() => _DailyDetailScreenState();
}

class _DailyDetailScreenState extends State<DailyDetailScreen> {
  final _tempController = TextEditingController();
  final _sensationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void dispose() {
    _tempController.dispose();
    _sensationController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final record = DailyRecord(
      id: '', // Firestore에서 자동 생성
      date: DateTime.now(),
      temperature: double.tryParse(_tempController.text) ?? 0.0,
      sensation: _sensationController.text.trim(),
    );

    await Provider.of<DailyRecordProvider>(context, listen: false)
        .addRecord(widget.uid, record);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기록이 저장되었습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('착용 기록 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tempController,
                decoration: const InputDecoration(labelText: '기온 (°C)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? '기온을 입력하세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sensationController,
                decoration: const InputDecoration(labelText: '체감 상태 (예: 더움, 적당함)'),
                validator: (value) =>
                value == null || value.isEmpty ? '체감 상태를 입력하세요' : null,
              ),
              const SizedBox(height: 24),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                onPressed: _saveRecord,
                icon: const Icon(Icons.save),
                label: const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
