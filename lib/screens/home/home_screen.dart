import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/routes.dart';
import '../../utils/session_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.userName, super.key});

  final String? userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    try {
      final cleared = await SessionStorage.clearSession();
      if (!mounted) {
        return;
      }
      if (!cleared) {
        _showMessage('Sesi gagal dihapus. Silakan coba lagi.');
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (_) => false,
      );
    } on PlatformException {
      if (mounted) {
        _showMessage('Penyimpanan sesi tidak dapat diakses.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.userName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Polowijen'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.theater_comedy,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                userName == null
                    ? 'Selamat datang di Polowijen!'
                    : 'Selamat datang, $userName!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login simulasi berhasil. Halaman ini menjadi tujuan '
                'navigasi Home.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
