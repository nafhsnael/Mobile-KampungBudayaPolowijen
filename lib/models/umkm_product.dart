class UmkmProduct {
  const UmkmProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.whatsappNumber,
    this.imageUrl,
  });

  final String name;
  final String description;
  final int price;
  final String category;
  final String whatsappNumber;
  final String? imageUrl;
}
