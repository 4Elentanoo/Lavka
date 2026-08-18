class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final int price; // в рублях, целыми — с double для денег беда с округлением
  final String category;

  Product copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
