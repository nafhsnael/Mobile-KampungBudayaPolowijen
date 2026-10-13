import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polowijen_mobile/screens/auth/login_screen.dart';
import 'package:polowijen_mobile/screens/main_container_screen.dart';
import 'package:polowijen_mobile/screens/umkm/umkm_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('validates required fields and minimum password length',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginScreen()),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'pengunjung');
    await tester.enterText(fields.at(1), '12345');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
  });

  testWidgets('bottom navigation switches between all five tabs',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainContainerScreen(userName: 'Tester'),
      ),
    );

    final tabs = [
      ('Home', 'Selamat datang, Tester!'),
      ('UMKM', 'Dukung UMKM Lokal'),
      ('Paket', 'Paket Kunjungan'),
      ('Event', 'Event & Agenda'),
      ('Profil', 'Tester'),
    ];

    for (final (label, pageTitle) in tabs) {
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
      expect(find.text(pageTitle), findsOneWidget);
    }
  });

  testWidgets('UMKM page filters products by category and search',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: UmkmScreen()),
    );

    expect(find.text('Dukung UMKM Lokal'), findsOneWidget);
    expect(find.text('Produk unggulan'), findsOneWidget);
    expect(find.text('Topeng Malang Panji Asmoro Bangun'), findsOneWidget);
    final craftCategory = find.text('Kerajinan').first;
    await tester.ensureVisible(craftCategory);
    await tester.tap(craftCategory);
    await tester.pumpAndSettle();
    expect(find.text('Jajanan'), findsNothing);
    expect(tester.takeException(), isNull);

    final searchField = find.byType(TextField);
    await tester.ensureVisible(searchField);
    await tester.enterText(searchField, 'Topeng');
    await tester.pumpAndSettle();
    expect(find.textContaining('Topeng Malang'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
