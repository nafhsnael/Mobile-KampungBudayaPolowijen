import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/session_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SessionStorage.isLoggedIn();

  runApp(PolowijenApp(isLoggedIn: isLoggedIn));
}
