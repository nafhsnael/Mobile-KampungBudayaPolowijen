import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/screens/auth/register_screen.dart';

void main() {
  testWidgets('register screen shows the designed form and validates fields',
      (tester) async {
    // Mengatur ukuran logical/physical size dengan proporsional untuk mobile
    tester.view.physicalSize = const Size(320, 696);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(320, 696)),
          child: RegisterScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Daftar Akun'), findsOneWidget);
    expect(find.text('Kampung Budaya'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    
    expect(tester.takeException(), isNull);

    // Validasi ketika tombol daftar ditekan tanpa mengisi field
    await tester.ensureVisible(find.text('Daftar'));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    expect(find.text('Konfirmasi password wajib diisi'), findsOneWidget);

    // Mengisi form dengan data uji
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Pengunjung Polowijen');
    await tester.enterText(fields.at(1), 'pengunjung@example.com');
    await tester.enterText(fields.at(2), 'rahasia123');
    await tester.enterText(fields.at(3), 'rahasia456');
    
    await tester.ensureVisible(find.text('Daftar'));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi password tidak cocok'), findsOneWidget);
  });
}