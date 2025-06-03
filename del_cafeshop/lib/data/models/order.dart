class Order {
  final int id;
  final String customerName;
  final List<Product> products;
  final String status;
  final DateTime? createdAt; // Made nullable to handle absence
  final DateTime? updatedAt; // Made nullable to handle absence
  final int? userId; // Already nullable, as per JSON

  Order({
    required this.id,
    required this.customerName,
    required this.products,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      customerName: json['customer_name'] as String? ?? 'Unknown', // Fallback to 'Unknown'
      id: json['order_id'] as int? ?? 0, // Fallback to 0 if missing
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((p) => Product.fromJson(p as Map<String, dynamic>))
              .toList()
          : [], // Fallback to empty list if missing
      status: json['status'] as String? ?? 'unknown', // Fallback to 'unknown'
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null, // Nullable if missing
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null, // Nullable if missing
      userId: json['user_id'] as int?, // Nullable, as per JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
    };
  }
}

class Product {
  final int productId;
  final String productName;
  final int price;
  final int quantity;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] as int? ?? 0, // Fallback to 0 if missing
      productName: json['product_name'] as String? ?? 'Unknown', // Fallback to 'Unknown'
      price: json['price'] as int? ?? 0, // Fallback to 0 if missing
      quantity: json['quantity'] as int? ?? 0, // Fallback to 0 if missing
    );
  }
}