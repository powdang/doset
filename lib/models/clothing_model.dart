class Clothing {
  final String id;
  final String name;
  final String category;
  final String season;
  final bool isWashed;

  Clothing({
    required this.id,
    required this.name,
    required this.category,
    required this.season,
    this.isWashed = true,
  });

  factory Clothing.fromJson(Map<String, dynamic> json, String docId) {
    return Clothing(
      id: docId,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      season: json['season'] ?? '',
      isWashed: json['isWashed'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'season': season,
      'isWashed': isWashed,
    };
  }
}
