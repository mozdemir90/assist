class User {
  final String id;
  final String username;
  final String email;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isActive': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
