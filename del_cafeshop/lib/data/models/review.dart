class Review {
  final String id;
  final String productId;
  final String userId;
  final String username;
  final double rating;
  final String comment;
  final DateTime createdAt;


  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    required this.createdAt,
  
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      username: json['username'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'userId': userId,
    'username': username,
    'rating': rating,
    'comment': comment,
  };
}