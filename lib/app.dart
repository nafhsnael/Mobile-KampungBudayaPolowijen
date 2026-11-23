import 'package:flutter/material.dart';

import 'core/config/routes.dart';
import 'core/config/theme.dart';

class PolowijenApp extends StatelessWidget {
  const PolowijenApp({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polowijen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoutes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
