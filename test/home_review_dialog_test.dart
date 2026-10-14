import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/screens/home/home_screen.dart';

void main() {
  testWidgets('rating and visitor review dialogs work together',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Lihat Ulasan'));
    await tester.pumpAndSettle();
    expect(find.text('5.0 / 5 dari 2 ulasan'), findsOneWidget);
    expect(find.text('nailaism'), findsOneWidget);
    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beri rating'));
    await tester.pumpAndSettle();
    expect(find.text('Bagaimana pengalamanmu?').last, findsOneWidget);
    expect(find.textContaining('/500'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).last,
      'Festivalnya sangat menarik.',
    );
    await tester.tap(find.byTooltip('Beri 4 bintang'));
    await tester.tap(find.text('Kirim ulasan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lihat Ulasan'));
    await tester.pumpAndSettle();
    expect(find.text('4.7 / 5 dari 3 ulasan'), findsOneWidget);
    expect(find.text('Festivalnya sangat menarik.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
