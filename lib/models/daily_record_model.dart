class DailyRecord {
  final String id;
  final DateTime date;
  final double temperature;
  final String sensation;

  DailyRecord({
    required this.id,
    required this.date,
    required this.temperature,
    required this.sensation,
  });

  factory DailyRecord.fromMap(Map<String, dynamic> map, String id) {
    return DailyRecord(
      id: id,
      date: DateTime.parse(map['date']),
      temperature: (map['temperature'] ?? 0).toDouble(),
      sensation: map['sensation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'temperature': temperature,
      'sensation': sensation,
    };
  }

  // ✅ Firestore 연동용 메서드
  factory DailyRecord.fromJson(Map<String, dynamic> json, String id) {
    return DailyRecord.fromMap(json, id);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
