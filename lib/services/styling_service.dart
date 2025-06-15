import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/styling_model.dart';

class StylingService {
  final CollectionReference _stylingRef =
  FirebaseFirestore.instance.collection('stylings');

  Future<void> addStyling(Styling styling, String userId) async {
    await _stylingRef.add({
      ...styling.toJson(),
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStyling(String id) async {
    await _stylingRef.doc(id).delete();
  }

  Future<List<Styling>> fetchStylings(String userId) async {
    final snapshot = await _stylingRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Styling.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
