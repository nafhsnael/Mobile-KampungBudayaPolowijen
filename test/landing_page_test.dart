import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polowijen_mobile/app.dart';
import 'package:polowijen_mobile/features/dashboard/presentation/pages/main_container_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('landing page opens the dashboard from the primary action',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PolowijenApp());
    await tester.pumpAndSettle();

    expect(find.text('Temukan kisah\nbudaya Polowijen'), findsOneWidget);
    expect(find.text('Mulai Jelajahi'), findsOneWidget);

    await tester.tap(find.text('Mulai Jelajahi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MainContainerScreen), findsOneWidget);
    expect(find.text('Kegiatan terdekat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
