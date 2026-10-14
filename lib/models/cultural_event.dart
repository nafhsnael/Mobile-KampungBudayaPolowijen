class CulturalEvent {
  static const tariTopengName = 'Tari Topeng';
  static const festivalBatikName = 'Festival Batik Polowijen';
  static const megenganNyadranName = 'Megengan & Nyadran';

  const CulturalEvent({
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl,
  });

  final String name;
  final String description;
  final String location;
  final DateTime date;
  final String? imageUrl;
}
