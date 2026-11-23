import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/routes.dart';
import '../../../../core/utils/session_storage.dart';
import '../../domain/entities/app_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.userName,
    this.onUserNameChanged,
    super.key,
  });

  final String? userName;
  final ValueChanged<String>? onUserNameChanged;

  static const placeholderUser = AppUser(
    name: 'Pengunjung Polowijen',
    email: 'pengunjung@example.com',
  );

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _cream = Color(0xFFFFF8EA);
  static const _brown = Color(0xFF4B291F);
  static const _terracotta = Color(0xFFA44132);

  late final TextEditingController _nameController;
  final _emailController =
      TextEditingController(text: ProfileScreen.placeholderUser.email);
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userName ?? ProfileScreen.placeholderUser.name,
    );
    _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final isLoggedIn = await SessionStorage.isLoggedIn();
      final userName = isLoggedIn
          ? widget.userName ?? await SessionStorage.getUserName()
          : null;
      if (!mounted) return;
      setState(() {
        _isLoggedIn = isLoggedIn;
        if (isLoggedIn && userName != null) {
          _nameController.text = userName;
        }
      });
    } on PlatformException {
      if (mounted) {
        setState(() => _isLoggedIn = false);
        _showMessage('Status login tidak dapat diperiksa.');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Nama lengkap wajib diisi.');
      return;
    }

    final password = _passwordController.text;
    final confirmation = _confirmationController.text;
    if (password.isNotEmpty || confirmation.isNotEmpty) {
      if (password.length < 6) {
        _showMessage('Password minimal 6 karakter.');
        return;
      }
      if (password != confirmation) {
        _showMessage('Konfirmasi password tidak cocok.');
        return;
      }
      _showMessage('Pengubahan password belum tersedia.');
      return;
    }

    try {
      final saved = await SessionStorage.updateUserName(name);
      if (!mounted) return;
      if (!saved) {
        _showMessage('Profil gagal disimpan. Silakan coba lagi.');
        return;
      }
      widget.onUserNameChanged?.call(name);
      _showMessage('Profil berhasil disimpan.');
    } on PlatformException {
      if (mounted) {
        _showMessage('Penyimpanan profil tidak dapat diakses.');
      }
    }
  }

  Future<void> _logout() async {
    try {
      final cleared = await SessionStorage.clearSession();
      if (!mounted) return;
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

  void _openLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  void _openRegister() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.register,
      (_) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text('Profile'),
        toolbarHeight: 48,
        backgroundColor: _cream,
        foregroundColor: _brown,
      ),
      body: _isLoggedIn == null
          ? const Center(
              child: CircularProgressIndicator(color: _terracotta),
            )
          : _isLoggedIn!
              ? _buildAuthenticatedProfile()
              : _buildGuestProfile(),
    );
  }

  Widget _buildAuthenticatedProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _ProfileHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileField(
                  label: 'Nama Lengkap',
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Ubah Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _ProfileField(
                  label: 'Konfirmasi Password',
                  controller: _confirmationController,
                  obscureText: true,
                ),
                const SizedBox(height: 28),
                Center(
                  child: SizedBox(
                    width: 140,
                    child: FilledButton(
                      onPressed: _saveProfile,
                      style: FilledButton.styleFrom(
                        backgroundColor: _terracotta,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 140,
                    child: FilledButton(
                      onPressed: _logout,
                      style: FilledButton.styleFrom(
                        backgroundColor: _terracotta,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _ProfileHeader(showEditButton: false),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: _terracotta,
                  size: 42,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kamu belum login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _brown,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masuk untuk melihat dan mengelola profilmu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF75665A),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 180,
                  child: FilledButton(
                    onPressed: _openLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: _terracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _openRegister,
                  style: TextButton.styleFrom(foregroundColor: _brown),
                  child: const Text('Belum punya akun? Daftar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({this.showEditButton = true});

  static const _brown = Color(0xFF4B291F);
  static const _cream = Color(0xFFFFF8EA);
  static const _gold = Color(0xFFC4933F);

  final bool showEditButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: _CurvedHeaderClipper(),
              child: const ColoredBox(color: _brown),
            ),
          ),
          Positioned(
            top: 24,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: _cream,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 49,
                backgroundColor: Color(0xFF8A6653),
                child: Icon(Icons.person, size: 54, color: _cream),
              ),
            ),
          ),
          if (showEditButton)
            Positioned(
              top: 105,
              left: MediaQuery.sizeOf(context).width / 2 + 28,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _cream,
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1.5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.edit, size: 13, color: _brown),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.38)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.94,
        size.width * 0.82,
        size.height * 0.94,
        size.width,
        size.height * 0.38,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool readOnly;

  static const _brown = Color(0xFF4B291F);
  static const _gold = Color(0xFFC4933F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: _brown,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            obscureText: obscureText,
            readOnly: readOnly,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: _brown,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: _gold, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: _gold, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: _gold, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
