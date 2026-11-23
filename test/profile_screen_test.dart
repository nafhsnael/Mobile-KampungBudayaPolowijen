import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:polowijen_mobile/core/config/routes.dart';
import 'package:polowijen_mobile/core/utils/session_storage.dart';
import 'package:polowijen_mobile/features/profile/presentation/pages/profile_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SessionStorage.saveSession('Tester');
  });

  testWidgets('profile shows edit fields and account actions without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: ProfileScreen(userName: 'Tester')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Ubah Password'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving a profile name preserves the existing login session',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? updatedName;
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          userName: 'Tester',
          onUserNameChanged: (name) => updatedName = name,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Nama Baru');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(updatedName, 'Nama Baru');
    expect(await SessionStorage.getUserName(), 'Nama Baru');
    expect(await SessionStorage.isLoggedIn(), isTrue);
    expect(find.text('Profil berhasil disimpan.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guest profile prompts the user to log in', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await SessionStorage.clearSession();

    await tester.pumpWidget(
      MaterialApp(
        home: const ProfileScreen(),
        routes: {
          AppRoutes.login: (_) => const Scaffold(body: Text('Login page')),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kamu belum login'), findsOneWidget);
    expect(find.text('Masuk untuk melihat dan mengelola profilmu.'),
        findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Belum punya akun? Daftar'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsNothing);
    expect(find.text('Simpan'), findsNothing);
    expect(find.text('Logout'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Login page'), findsOneWidget);
  });
}
