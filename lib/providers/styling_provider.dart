import 'package:flutter/material.dart';
import '../models/styling_model.dart';
import '../services/styling_service.dart';

class StylingProvider with ChangeNotifier {
  final StylingService _service = StylingService();
  List<Styling> _stylings = [];
  String? _userId;

  List<Styling> get stylings => _stylings;

  void setUser(String userId) {
    _userId = userId;
    loadStylings();
  }

  Future<void> loadStylings() async {
    if (_userId == null) return;
    _stylings = await _service.fetchStylings(_userId!);
    notifyListeners();
  }

  Future<void> addStyling(Styling styling) async {
    if (_userId == null) return;
    await _service.addStyling(styling, _userId!);
    await loadStylings();
  }

  Future<void> deleteStyling(String id) async {
    await _service.deleteStyling(id);
    _stylings.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
