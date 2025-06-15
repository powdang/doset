import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_record_model.dart';

class DailyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 데일리 기록 추가
  Future<void> addDailyRecord(String uid, DailyRecord record) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyRecords')
        .add(record.toJson());
  }

  /// 데일리 기록 삭제
  Future<void> deleteDailyRecord(String uid, String recordId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyRecords')
        .doc(recordId)
        .delete();
  }

  /// 데일리 기록 전체 가져오기
  Future<List<DailyRecord>> fetchDailyRecords(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyRecords')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => DailyRecord.fromJson(doc.data(), doc.id))
        .toList();
  }
}
