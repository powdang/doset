import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> register({
    required String email,
    required String password,
    required String nickname,
    required String userId,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'nickname': nickname,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // 성공
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return '알 수 없는 오류가 발생했습니다';
    }
  }

  Future<String?> login({
    required String userId,
    required String password,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) return '존재하지 않는 아이디입니다';

      final email = snapshot.docs.first['email'];

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return '로그인 중 오류가 발생했습니다';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
