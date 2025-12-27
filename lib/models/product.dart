class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice * 100);
  }

  // Convert Product to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  // Create Product from Map (SQLite)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      originalPrice: (map['originalPrice'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      category: map['category'] as String,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
    );
  }

  // Create Product from API JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['title'] ?? 'Unknown Product',
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: ((json['price'] as num?)?.toDouble() ?? 0.0) * 1.3, // 30% markup for original price
      imageUrl: json['image'] ?? json['thumbnail'] ?? '',
      category: json['category'] ?? 'General',
      rating: (json['rating']?['rate'] as num?)?.toDouble() ?? 
              (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviewCount: json['rating']?['count'] as int? ?? 0,
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
