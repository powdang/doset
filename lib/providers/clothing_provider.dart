import 'package:flutter/material.dart';
import '../models/clothing_model.dart';
import '../services/clothing_service.dart';

class ClothingProvider with ChangeNotifier {
  final ClothingService _service = ClothingService();
  List<Clothing> _clothes = [];
  String? _userId;

  List<Clothing> get clothes => _clothes;

  void setUser(String userId) {
    _userId = userId;
    loadClothes();
  }

  Future<void> loadClothes() async {
    if (_userId == null) return;
    _clothes = await _service.fetchClothes(_userId!);
    notifyListeners();
  }

  Future<void> addClothing(Clothing clothing) async {
    if (_userId == null) return;
    await _service.addClothing(clothing, _userId!);
    await loadClothes();
  }

  Future<void> deleteClothing(String id) async {
    await _service.deleteClothing(id);
    _clothes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> toggleWashed(String id, bool isWashed) async {
    await _service.updateWashedStatus(id, isWashed);
    final index = _clothes.indexWhere((c) => c.id == id);
    if (index != -1) {
      _clothes[index] = Clothing(
        id: _clothes[index].id,
        name: _clothes[index].name,
        category: _clothes[index].category,
        season: _clothes[index].season,
        isWashed: isWashed,
      );
      notifyListeners();
    }
  }
}
