import '../entities/tour_activity.dart';

class TourGuidePlanner {
  static const transferMinutes = 10;

  static const activities = <TourActivity>[
    TourActivity(
      title: 'Jelajah Kampung Budaya',
      description:
          'Mengenal suasana kampung dan cerita budaya bersama warga Polowijen.',
      durationMinutes: 25,
      interests: {TourInterest.culture},
      icon: TourActivityIcon.explore,
    ),
    TourActivity(
      title: 'Mengenal Topeng Malangan',
      description:
          'Melihat karakter topeng dan mengenal makna di balik kesenian khas Malang.',
      durationMinutes: 25,
      interests: {TourInterest.culture, TourInterest.arts},
      icon: TourActivityIcon.mask,
    ),
    TourActivity(
      title: 'Tari Topeng',
      description:
          'Menyaksikan gerak tari dan mengenal cerita dalam tradisi Topeng Malangan.',
      durationMinutes: 35,
      interests: {TourInterest.culture, TourInterest.arts},
      icon: TourActivityIcon.dance,
    ),
    TourActivity(
      title: 'Batik & Ecoprint',
      description:
          'Melihat proses dan karya batik serta kerajinan tangan warga.',
      durationMinutes: 40,
      interests: {TourInterest.arts, TourInterest.crafts},
      icon: TourActivityIcon.craft,
    ),
    TourActivity(
      title: 'Singgah ke UMKM Kriya',
      description:
          'Menjelajahi produk kerajinan lokal dan mendukung karya perajin Polowijen.',
      durationMinutes: 25,
      interests: {TourInterest.crafts},
      icon: TourActivityIcon.storefront,
    ),
    TourActivity(
      title: 'Cicip Kuliner Lokal',
      description:
          'Mencoba pilihan kuliner dan minuman tradisional dari UMKM setempat.',
      durationMinutes: 25,
      interests: {TourInterest.culinary},
      icon: TourActivityIcon.food,
    ),
  ];

  static TourItinerary create({
    required int availableMinutes,
    required int visitorCount,
    required Set<TourInterest> interests,
  }) {
    if (availableMinutes <= 0) {
      throw ArgumentError.value(availableMinutes, 'availableMinutes');
    }
    if (visitorCount <= 0) {
      throw ArgumentError.value(visitorCount, 'visitorCount');
    }
    if (interests.isEmpty) {
      throw ArgumentError.value(interests, 'interests');
    }

    final rankedActivities = activities
        .where((activity) =>
            activity.interests.any((interest) => interests.contains(interest)))
        .toList()
      ..sort((first, second) {
        final scoreComparison = _score(second, interests).compareTo(
          _score(first, interests),
        );
        if (scoreComparison != 0) return scoreComparison;
        return activities.indexOf(first).compareTo(activities.indexOf(second));
      });

    final steps = <TourItineraryStep>[];
    var elapsedMinutes = 0;
    for (final activity in rankedActivities) {
      final travelMinutes = steps.isEmpty ? 0 : transferMinutes;
      final startMinute = elapsedMinutes + travelMinutes;
      final endMinute = startMinute + activity.durationMinutes;
      if (endMinute > availableMinutes) continue;

      steps.add(
        TourItineraryStep(
          activity: activity,
          startMinute: startMinute,
          endMinute: endMinute,
          travelBeforeMinutes: travelMinutes,
        ),
      );
      elapsedMinutes = endMinute;
    }

    return TourItinerary(
      visitorCount: visitorCount,
      availableMinutes: availableMinutes,
      steps: List.unmodifiable(steps),
      totalMinutes: elapsedMinutes,
    );
  }

  static int _score(TourActivity activity, Set<TourInterest> interests) {
    return activity.interests
        .where((interest) => interests.contains(interest))
        .length;
  }
}
