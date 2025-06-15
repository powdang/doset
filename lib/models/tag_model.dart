class Tag {
  final String id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromMap(Map<String, dynamic> map, String id) {
    return Tag(
      id: id,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
