import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/routes.dart';
import '../../utils/session_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _cream = Color(0xFFFFF8EA);
  static const _gold = Color(0xFFC99B45);
  static const _darkBrown = Color(0xFF49281F);
  static const _mutedRed = Color(0xFFA43E32);
  static const _mutedText = Color(0xFFD8C9B9);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    final userName = _nameController.text.trim();

    try {
      final saved = await SessionStorage.saveSession(userName);
      if (!mounted) {
        return;
      }
      if (!saved) {
        _showMessage('Akun gagal disimpan. Silakan coba lagi.');
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (_) => false,
        arguments: userName,
      );
    } on PlatformException {
      if (mounted) {
        _showMessage('Penyimpanan akun tidak dapat diakses.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAA9E93), fontSize: 11),
      prefixIcon: Icon(icon, size: 17, color: const Color(0xFF988B7E)),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 32,
      ),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 32,
      ),
      filled: true,
      fillColor: _cream,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE57373)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE57373), width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 9, height: 1.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: _darkBrown,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final contentWidth = (constraints.maxWidth * 0.8).clamp(250.0, 420.0);
          final horizontalPadding =
              ((constraints.maxWidth - contentWidth) / 2).clamp(0.0, 48.0);
          final heroHeight = screenHeight * 0.54;
          final topSpacing = safeTop + screenHeight * 0.10;

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/images.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.12),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x99502A20),
                            Color(0xAA48271F),
                            Color(0xFF49281F),
                          ],
                          stops: [0, 0.72, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    topSpacing,
                    horizontalPadding,
                    24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight - topSpacing - 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _BrandMark(),
                        SizedBox(height: screenHeight * 0.085),
                        const Text(
                          'Daftar Akun',
                          style: TextStyle(
                            color: Color(0xFFD6C66B),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Buat akun untuk jelajahi kekayaan\n'
                          'budaya "Kampung Budaya Polowijen"',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.038),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                style: const TextStyle(
                                  color: _darkBrown,
                                  fontSize: 11,
                                ),
                                decoration: _inputDecoration(
                                  hint: 'Nama Lengkap',
                                  icon: Icons.person_outline,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama lengkap wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 11),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                style: const TextStyle(
                                  color: _darkBrown,
                                  fontSize: 11,
                                ),
                                decoration: _inputDecoration(
                                  hint: 'Email',
                                  icon: Icons.mail_outline,
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  if (email.isEmpty) {
                                    return 'Email wajib diisi';
                                  }
                                  if (!RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  ).hasMatch(email)) {
                                    return 'Masukkan email yang valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 11),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                style: const TextStyle(
                                  color: _darkBrown,
                                  fontSize: 11,
                                ),
                                decoration: _inputDecoration(
                                  hint: 'Password',
                                  icon: Icons.lock_outline,
                                  suffix: _visibilityButton(
                                    _obscurePassword,
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return 'Password minimal 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 11),
                              TextFormField(
                                controller: _confirmationController,
                                obscureText: _obscureConfirmation,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _register(),
                                style: const TextStyle(
                                  color: _darkBrown,
                                  fontSize: 11,
                                ),
                                decoration: _inputDecoration(
                                  hint: 'Konfirmasi Password',
                                  icon: Icons.lock_outline,
                                  suffix: _visibilityButton(
                                    _obscureConfirmation,
                                    () => setState(
                                      () => _obscureConfirmation =
                                          !_obscureConfirmation,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Konfirmasi password wajib diisi';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Konfirmasi password tidak cocok';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.048),
                        Center(
                          child: SizedBox(
                            width: 170,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _gold,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: _gold,
                                shape: const StadiumBorder(),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        const _OrDivider(),
                        SizedBox(height: screenHeight * 0.04),
                        Center(
                          child: SizedBox(
                            width: 170,
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () => _showMessage(
                                'Pendaftaran dengan Google belum tersedia.',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _mutedRed,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              label: const Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.028),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  color: _mutedText,
                                  fontSize: 9,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: _gold,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Masuk sekarang',
                                  style: TextStyle(
                                    fontSize: 9,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _visibilityButton(bool obscure, VoidCallback onPressed) {
    return IconButton(
      tooltip: obscure ? 'Tampilkan password' : 'Sembunyikan password',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      visualDensity: VisualDensity.compact,
      splashRadius: 16,
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 16,
        color: const Color(0xFF988B7E),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Kampung Budaya',
          style: TextStyle(color: Colors.white, fontSize: 10, height: 1.1),
        ),
        Text(
          'Polowijen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFB99A84), endIndent: 24)),
        Text(
          'atau masuk dengan',
          style: TextStyle(color: Color(0xFFD8C9B9), fontSize: 9),
        ),
        Expanded(child: Divider(color: Color(0xFFB99A84), indent: 24)),
      ],
    );
  }
}
