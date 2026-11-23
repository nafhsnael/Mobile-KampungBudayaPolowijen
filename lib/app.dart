import 'package:flutter/material.dart';

import 'core/config/routes.dart';
import 'core/config/theme.dart';

class PolowijenApp extends StatelessWidget {
  const PolowijenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polowijen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.landing,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoutes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
