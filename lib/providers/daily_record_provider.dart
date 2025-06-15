import 'package:flutter/material.dart';
import '../models/daily_record_model.dart';
import '../services/daily_service.dart';

class DailyRecordProvider extends ChangeNotifier {
  final List<DailyRecord> _records = [];

  List<DailyRecord> get records => _records;

  /// Firestore에서 기록 불러오기
  Future<void> fetchRecords(String uid) async {
    final fetched = await DailyService().fetchDailyRecords(uid); // ✅ 올바른 메서드 이름
    _records
      ..clear()
      ..addAll(fetched);
    notifyListeners();
  }

  /// 기록 추가
  Future<void> addRecord(String uid, DailyRecord record) async {
    _records.add(record);
    notifyListeners();
    await DailyService().addDailyRecord(uid, record); // ✅ 메서드 이름 일치
  }

  /// 기록 삭제
  Future<void> deleteRecord(String uid, DailyRecord record) async {
    _records.removeWhere((r) => r.id == record.id);
    notifyListeners();
    await DailyService().deleteDailyRecord(uid, record.id); // ✅ 올바른 메서드 이름
  }

  /// 날짜 필터링 (선택적)
  List<DailyRecord> recordsForDate(DateTime date) {
    return _records.where(
          (r) =>
      r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day,
    ).toList();
  }
}
