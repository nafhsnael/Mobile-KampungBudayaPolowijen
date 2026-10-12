import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_container_screen.dart';
import '../screens/paket_kunjungan/booking_form_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  static const home = '/home';
  static const umkm = '/umkm';
  static const paketKunjungan = '/paket-kunjungan';
  static const event = '/event';
  static const profile = '/profile';
  static const bookingForm = '/booking-form';

  static const _tabRoutes = <String, int>{
    main: 0,
    home: 0,
    umkm: 1,
    paketKunjungan: 2,
    event: 3,
    profile: 4,
  };

  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) {
    final route = onGenerateRoute(RouteSettings(name: initialRoute));
    return [route ?? _unknownRoute(RouteSettings(name: initialRoute))];
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case bookingForm:
        return MaterialPageRoute<void>(
          builder: (_) => const BookingFormScreen(),
          settings: settings,
        );
      default:
        final selectedIndex = _tabRoutes[settings.name];
        if (selectedIndex == null) {
          return null;
        }
        final userName =
            settings.arguments is String ? settings.arguments as String : null;
        return MaterialPageRoute<void>(
          builder: (_) => MainContainerScreen(
            initialIndex: selectedIndex,
            userName: userName,
          ),
          settings: settings,
        );
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _unknownRoute(settings);
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
        body: Center(
          child: Text('Rute ${settings.name ?? '(kosong)'} tidak tersedia.'),
        ),
      ),
      settings: settings,
    );
  }
}
