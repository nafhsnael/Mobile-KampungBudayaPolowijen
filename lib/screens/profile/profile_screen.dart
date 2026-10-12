import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/routes.dart';
import '../../models/app_user.dart';
import '../../utils/session_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({this.userName, super.key});

  final String? userName;
  static const _placeholderUser = AppUser(
    name: 'Pengunjung Polowijen',
    email: 'pengunjung@example.com',
  );

  Future<void> _logout(BuildContext context) async {
    try {
      final cleared = await SessionStorage.clearSession();
      if (!context.mounted) {
        return;
      }
      if (!cleared) {
        _showMessage(context, 'Sesi gagal dihapus. Silakan coba lagi.');
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (_) => false,
      );
    } on PlatformException {
      if (context.mounted) {
        _showMessage(context, 'Penyimpanan sesi tidak dapat diakses.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final name = userName ?? _placeholderUser.name;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            _placeholderUser.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit Profil'),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Pemesanan'),
          ),
          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Bantuan'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
