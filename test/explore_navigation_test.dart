import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/screens/main_container_screen.dart';

void main() {
  testWidgets('Home explore banner opens category details', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainContainerScreen()));
    await tester.tap(find.text('Jelajahi Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Jelajahi Polowijen'), findsOneWidget);
    await tester.tap(find.text('Seni & Topeng').last);
    await tester.pumpAndSettle();
    expect(find.text('Tentang Topeng Malangan'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tari Tradisional').last);
    await tester.pumpAndSettle();
    expect(find.text('Tentang Tari Tradisional'), findsOneWidget);
    final activityButton = find.text('Lihat Detail');
    await tester.ensureVisible(activityButton);
    await tester.tap(activityButton);
    await tester.pumpAndSettle();
    expect(find.text('Tari Topeng'), findsOneWidget);
    expect(find.text('Tentang Kegiatan'), findsOneWidget);
    expect(find.text('120 Kursi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home nearest event opens Tari Topeng detail', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainContainerScreen()));
    final eventButton = find.text('Ikuti Acara');
    await tester.ensureVisible(eventButton);
    await tester.tap(eventButton);
    await tester.pumpAndSettle();

    expect(find.text('Tari Topeng'), findsOneWidget);
    expect(find.text('Tentang Kegiatan'), findsOneWidget);
    expect(find.text('25 Okt 2026 · 15.00 WIB'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Explore activities open their matching event details',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainContainerScreen()));

    for (final (category, eventName) in [
      ('Batik & Kerajinan', 'Festival Batik Polowijen'),
      ('Pengalaman Budaya', 'Megengan & Nyadran'),
    ]) {
      await tester.tap(find.text('Jelajahi Sekarang'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('explore-category-$category')));
      await tester.pumpAndSettle();

      final activityButton = find.text('Lihat Detail');
      await tester.ensureVisible(activityButton);
      await tester.tap(activityButton);
      await tester.pumpAndSettle();

      expect(find.text(eventName), findsOneWidget);
      expect(find.text('Tentang Kegiatan'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });
}
