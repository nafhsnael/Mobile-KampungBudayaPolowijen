class VisitPackage {
  const VisitPackage({
    required this.name,
    required this.description,
    required this.pricePerPerson,
    required this.duration,
    this.facilities = const [],
    this.imageAsset,
    this.imageUrl,
  });

  final String name;
  final String description;
  final int pricePerPerson;
  final String duration;
  final List<String> facilities;
  final String? imageAsset;
  final String? imageUrl;
}
