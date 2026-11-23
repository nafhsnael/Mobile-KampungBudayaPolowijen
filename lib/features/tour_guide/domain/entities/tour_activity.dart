enum TourInterest {
  culture('Budaya'),
  arts('Seni & Tari'),
  crafts('Kerajinan'),
  culinary('Kuliner');

  const TourInterest(this.label);

  final String label;
}

enum TourActivityIcon {
  explore,
  mask,
  dance,
  craft,
  storefront,
  food,
}

class TourActivity {
  const TourActivity({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.interests,
    required this.icon,
  });

  final String title;
  final String description;
  final int durationMinutes;
  final Set<TourInterest> interests;
  final TourActivityIcon icon;
}

class TourItineraryStep {
  const TourItineraryStep({
    required this.activity,
    required this.startMinute,
    required this.endMinute,
    required this.travelBeforeMinutes,
  });

  final TourActivity activity;
  final int startMinute;
  final int endMinute;
  final int travelBeforeMinutes;
}

class TourItinerary {
  const TourItinerary({
    required this.visitorCount,
    required this.availableMinutes,
    required this.steps,
    required this.totalMinutes,
  });

  final int visitorCount;
  final int availableMinutes;
  final List<TourItineraryStep> steps;
  final int totalMinutes;
}
