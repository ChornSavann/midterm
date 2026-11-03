class Product {
  final int id;
  final String title, description, category, thumbnail;
  final double price, rating;

  Product({required this.id, required this.title, required this.description, required this.category,
      required this.thumbnail, required this.price, required this.rating});

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        category: j['category'] ?? '',
        thumbnail: j['thumbnail'] ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
      );
}
