class Styling {
  final String id;
  final String name;
  final String description;
  final List<String> clothingIds;

  Styling({
    required this.id,
    required this.name,
    required this.description,
    required this.clothingIds,
  });

  factory Styling.fromJson(Map<String, dynamic> json, String docId) {
    return Styling(
      id: docId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      clothingIds: List<String>.from(json['clothingIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'clothingIds': clothingIds,
    };
  }
}
