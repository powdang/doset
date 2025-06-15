import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clothing_model.dart';

class ClothingService {
  final CollectionReference _clothesRef =
  FirebaseFirestore.instance.collection('clothes');

  Future<void> addClothing(Clothing clothing, String userId) async {
    await _clothesRef.add({
      ...clothing.toJson(),
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClothing(String id) async {
    await _clothesRef.doc(id).delete();
  }

  Future<List<Clothing>> fetchClothes(String userId) async {
    final snapshot = await _clothesRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Clothing.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateWashedStatus(String id, bool isWashed) async {
    await _clothesRef.doc(id).update({'isWashed': isWashed});
  }
}
