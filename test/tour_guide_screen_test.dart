import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polowijen_mobile/features/dashboard/presentation/pages/main_container_screen.dart';
import 'package:polowijen_mobile/features/tour_guide/presentation/pages/tour_guide_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('generates a local itinerary from duration and interests',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: TourGuideScreen()));
    await tester.tap(find.byKey(const ValueKey('create-itinerary')));
    await tester.pumpAndSettle();

    expect(find.text('Rencana kunjunganmu'), findsOneWidget);
    expect(find.text('3 orang'), findsOneWidget);
    expect(find.textContaining('Mengenal Topeng Malangan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard AI logo opens the tour guide', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: MainContainerScreen(userName: 'Tester')),
    );
    await tester.pump();
    expect(find.byTooltip('Buka AI Personal Tour Guide'), findsOneWidget);

    await tester.tap(find.byTooltip('Buka AI Personal Tour Guide'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('AI Personal Tour Guide'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
