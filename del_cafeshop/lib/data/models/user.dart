// lib/data/models/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final String? imageUrl; // Tambahkan field ini

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }
}