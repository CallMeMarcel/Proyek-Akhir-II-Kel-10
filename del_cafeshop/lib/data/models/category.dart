class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  // Menggunakan getter untuk productCount, ini bisa dihitung atau dibiarkan default
  int get productCount => 0; // Default ke 0 jika tidak ada produk

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
