import 'package:flutter/material.dart';

import '../../../../core/config/routes.dart';
import '../../../tour_guide/presentation/widgets/tour_guide_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const _maroon = Color(0xFF702B2E);
  static const _cream = Color(0xFFFFF8EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(
                onExplore: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.home,
                ),
                onLogin: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cerita yang bisa kamu alami',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _maroon,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Temukan budaya, karya, dan keramahan warga Polowijen.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF75665A),
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.theater_comedy_outlined,
                            title: 'Budaya',
                            subtitle: 'Kenali kisah lokal',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.storefront_outlined,
                            title: 'UMKM',
                            subtitle: 'Dukung karya warga',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: Icons.event_available_outlined,
                            title: 'Kegiatan',
                            subtitle: 'Jadwalkan kunjungan',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: _maroon,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Kampung Budaya Polowijen · Malang',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.4,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.onExplore,
    required this.onLogin,
  });

  final VoidCallback onExplore;
  final VoidCallback onLogin;

  static const _gold = Color(0xFFD5A64A);

  @override
  Widget build(BuildContext context) {
    final height =
        (MediaQuery.sizeOf(context).height * 0.72).clamp(520.0, 680.0);

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/login.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.15),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66301716),
                  Color(0x55301716),
                  Color(0xF2221715),
                ],
                stops: [0, 0.35, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 54, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 42,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'KAMPUNG BUDAYA\nPOLOWIJEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onLogin,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Masuk'),
                    ),
                    const TourGuideLauncher(heroTag: 'landing-tour-guide'),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: _gold.withValues(alpha: 0.65)),
                  ),
                  child: const Text(
                    'WARISAN BUDAYA MALANG',
                    style: TextStyle(
                      color: Color(0xFFFFE3A3),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Temukan kisah\nbudaya Polowijen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Jelajahi tradisi, temui karya warga, dan rencanakan pengalamanmu di Kampung Budaya.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onExplore,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Mulai Jelajahi'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE0B65D),
                      foregroundColor: const Color(0xFF3B211D),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: Color(0xFFFFE3A3), size: 17),
                    SizedBox(width: 5),
                    Text(
                      'Polowijen, Kota Malang',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.fromLTRB(12, 14, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECE2D3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: LandingPage._maroon, size: 24),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: LandingPage._maroon,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF75665A),
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
