import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polowijen_mobile/features/umkm/presentation/pages/umkm_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens an empty wishlist and returns to the UMKM catalog',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: UmkmScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buka wishlist'));
    await tester.pumpAndSettle();

    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('0 produk tersimpan'), findsOneWidget);
    expect(find.text('Wishlist kamu masih kosong.'), findsOneWidget);

    await tester.tap(find.byTooltip('Kembali ke katalog UMKM'));
    await tester.pumpAndSettle();
    expect(find.text('Dukung UMKM Lokal'), findsOneWidget);
  });

  testWidgets('favorites persist, can be searched, and can be removed',
      (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: UmkmScreen()));
    await tester.pumpAndSettle();

    final saveButtons = find.byTooltip('Simpan ke wishlist');
    await tester.tap(saveButtons.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Simpan ke wishlist').first);
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('umkmWishlist'), hasLength(2));

    await tester.tap(find.byTooltip('Buka wishlist'));
    await tester.pumpAndSettle();
    expect(find.text('2 produk tersimpan'), findsOneWidget);
    expect(find.text('Topeng Malang Panji Asmoro Bangun'), findsOneWidget);
    expect(find.text('Topeng Malang Dewi Sekartaji'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Dewi');
    await tester.pumpAndSettle();
    expect(find.text('Topeng Malang Dewi Sekartaji'), findsOneWidget);
    expect(find.text('Topeng Malang Panji Asmoro Bangun'), findsNothing);

    await tester.tap(find.byTooltip('Hapus dari wishlist'));
    await tester.pumpAndSettle();
    expect(find.text('1 produk tersimpan'), findsOneWidget);
    expect(preferences.getStringList('umkmWishlist'), hasLength(1));
  });
}
