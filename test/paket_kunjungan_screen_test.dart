import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polowijen_mobile/screens/paket_kunjungan/paket_kunjungan_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('package cards open details and return to the package list',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: PaketKunjunganScreen()),
    );

    await tester.tap(find.text('Paket Sambang Kampung'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Paket'), findsOneWidget);
    expect(find.text('Rp 50.000 / orang · 3 jam'), findsOneWidget);
    expect(find.text('Pesan Paket'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali ke paket'));
    await tester.pumpAndSettle();

    expect(find.text('Paket Kunjungan'), findsOneWidget);
    expect(find.text('Paket Sambang Kampung'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('routine activities open their detail sheet', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: PaketKunjunganScreen()),
    );

    await tester.tap(find.text('Jadwal Rutin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sarasehan Budaya Malang'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Kegiatan'), findsOneWidget);
    expect(find.text('Jumat, 19.00–21.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
