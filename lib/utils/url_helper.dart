import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class UrlHelper {
  static Future<bool> openWhatsApp(
    String phoneNumber, {
    String message = '',
  }) {
    final normalizedPhone = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.https('wa.me', '/$normalizedPhone', {'text': message});
    return _launch(uri);
  }

  static Future<bool> openMaps(String query) {
    final uri = Uri.https(
        'www.google.com', '/maps/search/', {'api': '1', 'query': query});
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) async {
    if (uri.pathSegments.isEmpty ||
        uri.pathSegments.any((part) => part.isEmpty)) {
      throw ArgumentError.value(uri, 'uri', 'URL tidak valid');
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static void showLaunchError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
