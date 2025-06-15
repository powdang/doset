import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 알림 전송
  Future<void> sendNotification(String uid, NotificationMessage message) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(message.id) // 고유 ID 직접 지정
        .set(message.toJson());
  }

  /// 알림 불러오기 (최신순 정렬)
  Future<List<NotificationMessage>> fetchNotifications(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return NotificationMessage.fromJson(doc.data(), doc.id);
    }).toList();
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String uid, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
