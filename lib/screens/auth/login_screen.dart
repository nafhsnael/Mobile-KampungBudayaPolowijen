import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/routes.dart';
import '../../utils/session_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _cream = Color(0xFFFFF8EA);
  static const _gold = Color(0xFFC99B45);
  static const _mutedRed = Color(0xFFA43E32);

  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final userName = _userNameController.text.trim();
    try {
      final saved = await SessionStorage.saveSession(userName);
      if (!mounted) {
        return;
      }
      if (!saved) {
        _showMessage('Sesi gagal disimpan. Silakan coba lagi.');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil. Selamat datang!')),
      );
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: userName,
      );
    } on PlatformException {
      if (mounted) {
        _showMessage('Penyimpanan sesi tidak dapat diakses.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16).clamp(0.0, 480.0);
            final cardHeight =
                (constraints.maxHeight - 16).clamp(620.0, double.infinity);
            final heroHeight =
                (constraints.maxHeight * 0.42).clamp(245.0, 310.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF49281F),
                          Color(0xFF4B291F),
                          Color(0xFF48271E),
                        ],
                      ),
                      border: Border.all(color: const Color(0xFF593428)),
                    ),
                    child: Stack(
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
                                'assets/images/login.jpg',
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, -0.12),
                              ),
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xAA351D18),
                                      Color(0x88351D18),
                                      Color(0xFF49281F),
                                    ],
                                    stops: [0, 0.58, 1],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 80, 28, 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _BrandMark(),
                                SizedBox(height: heroHeight - 186),
                                const _WelcomeCopy(),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _userNameController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autofillHints: const [
                                          AutofillHints.username,
                                        ],
                                        style: const TextStyle(
                                          color: Color(0xFF4B4039),
                                          fontSize: 12,
                                        ),
                                        decoration: _inputDecoration(
                                          hint: 'Email',
                                          icon: Icons.mail_outline,
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Email wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        textInputAction: TextInputAction.done,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        onFieldSubmitted: (_) {
                                          if (!_isLoading) {
                                            _login();
                                          }
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFF4B4039),
                                          fontSize: 12,
                                        ),
                                        decoration: _inputDecoration(
                                          hint: 'Password',
                                          icon: Icons.lock_outline,
                                          suffix: IconButton(
                                            tooltip: _obscurePassword
                                                ? 'Tampilkan password'
                                                : 'Sembunyikan password',
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password wajib diisi';
                                          }
                                          if (value.length < 6) {
                                            return 'Password minimal 6 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                _LoginOptions(
                                  rememberMe: _rememberMe,
                                  onRememberChanged: (value) {
                                    setState(() => _rememberMe = value);
                                  },
                                  onForgotPassword: () {
                                    _showMessage(
                                      'Fitur lupa password belum tersedia.',
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: SizedBox(
                                    width: 174,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _gold,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            _gold.withValues(alpha: 0.7),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: const StadiumBorder(),
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                                          : const Text('Login'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const _OrDivider(),
                                const SizedBox(height: 18),
                                Center(
                                  child: SizedBox(
                                    width: 174,
                                    height: 40,
                                    child: TextButton(
                                      onPressed: () {
                                        _showMessage(
                                          'Login Google belum tersedia.',
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: _mutedRed,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.zero,
                                        shape: const StadiumBorder(),
                                        textStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'G',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text('Google'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Text(
                                        'Belum punya akun? ',
                                        style: TextStyle(
                                          color: Color(0xFFD8C9B9),
                                          fontSize: 9,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.register,
                                          );
                                        },
                                        child: const Text(
                                          'Daftar sekarang',
                                          style: TextStyle(
                                            color: _gold,
                                            fontSize: 9,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: _gold,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
      suffixIcon: suffix,
      filled: true,
      fillColor: _cream,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: _gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFE57373)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFFE57373), width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 9, height: 1.1),
    );
  }
}

class _BrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 38,
          height: 52,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kampung Budaya',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
            Text(
              'Polowijen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang',
          style: GoogleFonts.dancingScript(
            color: const Color(0xFFD0A44F),
            fontSize: 25,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 1),
        const Text(
          'Di Kampung Budaya Polowijen',
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
        const SizedBox(height: 5),
        const Text(
          'Jelajahi kekayaan budaya, temukan\n'
          'cerita dibalik setiap karya, dan dukung\n'
          'UMKM lokal',
          style: TextStyle(
            color: Color(0xFFD8C9B9),
            fontSize: 10,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _LoginOptions extends StatelessWidget {
  const _LoginOptions({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 24,
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) => onRememberChanged(value ?? false),
            activeColor: const Color(0xFFC99B45),
            side: const BorderSide(color: Color(0xFFD8C9B9)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Ingat saya',
          style: TextStyle(color: Color(0xFFD8C9B9), fontSize: 8),
        ),
        const Spacer(),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFD8C9B9),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            minimumSize: const Size(0, 28),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(fontSize: 8),
          ),
          child: const Text('Lupa password'),
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
        Expanded(child: Divider(color: Color(0xFFB99A84), endIndent: 16)),
        Text(
          'atau masuk dengan',
          style: TextStyle(color: Color(0xFFD8C9B9), fontSize: 9),
        ),
        Expanded(child: Divider(color: Color(0xFFB99A84), indent: 16)),
      ],
    );
  }
}
