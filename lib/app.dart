import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'config/theme.dart';

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
