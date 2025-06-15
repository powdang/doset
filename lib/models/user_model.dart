class AppUser {
  final String uid;
  final String userId;
  final String nickname;
  final String email;

  AppUser({
    required this.uid,
    required this.userId,
    required this.nickname,
    required this.email,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      userId: map['userId'] ?? '',
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickname': nickname,
      'email': email,
    };
  }
}
