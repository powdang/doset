class NotificationMessage {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  NotificationMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json, String id) {
    return NotificationMessage(
      id: id,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}
