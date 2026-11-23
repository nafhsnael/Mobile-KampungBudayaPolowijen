import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/features/tour_guide/domain/entities/tour_activity.dart';
import 'package:polowijen_mobile/features/tour_guide/domain/services/tour_guide_planner.dart';

void main() {
  test('itinerary uses visitor count, matching interests, and fits the time', () {
    final itinerary = TourGuidePlanner.create(
      availableMinutes: 120,
      visitorCount: 3,
      interests: {TourInterest.culture, TourInterest.arts},
    );

    expect(itinerary.visitorCount, 3);
    expect(itinerary.availableMinutes, 120);
    expect(itinerary.steps, isNotEmpty);
    expect(itinerary.totalMinutes, lessThanOrEqualTo(120));
    expect(
      itinerary.steps.every((step) =>
          step.activity.interests.any(
            {TourInterest.culture, TourInterest.arts}.contains,
          )),
      isTrue,
    );
    expect(
      itinerary.steps.map((step) => step.startMinute),
      orderedEquals(
        itinerary.steps.map((step) => step.startMinute).toList()..sort(),
      ),
    );
  });

  test('culinary preference recommends the local culinary stop', () {
    final itinerary = TourGuidePlanner.create(
      availableMinutes: 60,
      visitorCount: 2,
      interests: {TourInterest.culinary},
    );

    expect(itinerary.steps, hasLength(1));
    expect(itinerary.steps.single.activity.title, 'Cicip Kuliner Lokal');
  });
}
