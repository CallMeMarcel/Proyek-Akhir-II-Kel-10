import 'dart:convert';
import 'package:get/get.dart'; // ⬅️ Diperlukan untuk RxInt
import 'category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String status;
  final String title;
  final double price;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int categoryId;
  final Category category;

  RxInt quantity; // ✅ Jadikan reactive

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.title,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.category,
    int quantity = 1,
  }) : quantity = quantity.obs;

  /// Getter untuk thumbnail, misalnya menggunakan image
  String get thumbnail => image;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'available',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      categoryId: json['category_id'] ?? 0,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(id: 0, name: 'Uncategorized'),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'title': title,
      'price': price,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category_id': categoryId,
      'category': category.toJson(),
      'quantity': quantity.value, 
    };
  }

  get toppings => null; // Placeholder for toppings, if needed

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  String toRawJson() => jsonEncode(toJson());

  factory Product.fromRawJson(String str) => Product.fromJson(jsonDecode(str));
}



