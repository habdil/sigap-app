class User {
  final String id;
  final String username;
  final String email;
  final String? token;
  final String? googleId;
  final String? avatarUrl; // Opsional

  User({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.googleId,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '0').toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] as String?,
      googleId: json['google_id'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'google_id': googleId,
      'avatar_url': avatarUrl,
    };
  }
}