import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/screens/event/event_screen.dart';

void main() {
  testWidgets('each event card opens its detail page', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: EventScreen()));

    for (final eventName in [
      'Tari Topeng',
      'Festival Batik Polowijen',
      'Megengan & Nyadran',
    ]) {
      final detailButton = find.byKey(ValueKey('open-event-$eventName'));
      await tester.ensureVisible(detailButton);
      await tester.tap(detailButton);
      await tester.pumpAndSettle();

      expect(find.text(eventName), findsOneWidget);
      expect(find.text('Tentang Kegiatan'), findsOneWidget);
      expect(find.text('120 Kursi'), findsOneWidget);
      expect(find.text('Rp. 50.000 / Orang'), findsOneWidget);

      await tester.tap(find.byTooltip('Kembali ke daftar event'));
      await tester.pumpAndSettle();
      expect(find.text('Event & Kegiatan'), findsOneWidget);
    }

    expect(tester.takeException(), isNull);
  });
}
