import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/visit_package.dart';

class PaketKunjunganScreen extends StatefulWidget {
  const PaketKunjunganScreen({super.key});

  @override
  State<PaketKunjunganScreen> createState() => _PaketKunjunganScreenState();
}

class _PaketKunjunganScreenState extends State<PaketKunjunganScreen> {
  static const _packages = [
    VisitPackage(
      name: 'Paket Sambang Kampung',
      description: 'Jelajahi budaya dan keseharian warga Polowijen.',
      pricePerPerson: 50000,
      duration: '3 jam',
      facilities: ['Pemandu lokal', 'Dokumentasi', 'Edukasi budaya'],
      imageAsset: 'assets/images/festivalkampung.jpeg',
    ),
    VisitPackage(
      name: 'Paket Jelajah Budaya',
      description: 'Kenali sejarah dan tradisi Kampung Budaya Polowijen.',
      pricePerPerson: 35000,
      duration: '2 jam',
      facilities: ['Pemandu lokal', 'Edukasi budaya'],
      imageAsset: 'assets/images/nyadran.png',
    ),
    VisitPackage(
      name: 'Paket Tari Tradisi',
      description: 'Saksikan dan pelajari ragam tari tradisional Malang.',
      pricePerPerson: 50000,
      duration: '2 jam',
      facilities: ['Pertunjukan tari', 'Pemandu lokal'],
      imageAsset: 'assets/images/taritopeng.png',
    ),
    VisitPackage(
      name: 'Paket Belajar Topeng',
      description: 'Belajar mengenal dan mewarnai topeng Malangan.',
      pricePerPerson: 50000,
      duration: '2 jam',
      facilities: ['Topeng', 'Alat dan bahan', 'Pemandu'],
      imageAsset: 'assets/images/topeng.jpg',
    ),
    VisitPackage(
      name: 'Paket Sinau Budaya',
      description: 'Pengalaman belajar budaya bersama warga setempat.',
      pricePerPerson: 35000,
      duration: '2 jam',
      facilities: ['Pemandu lokal', 'Edukasi budaya'],
      imageAsset: 'assets/images/gamelan.png',
    ),
  ];

  static const _activities = [
    _RoutineActivity(
      name: 'Sarasehan Budaya Malang',
      day: 'Jumat',
      time: '19.00–21.00',
      description: 'Berbagi pengalaman, melihat kehidupan serta melestarikan '
          'kesenian dan budaya di Kampung Polowijen.',
      imageAsset: 'assets/images/nyadran.png',
    ),
    _RoutineActivity(
      name: 'Bantengan/Jaranan',
      day: 'Sabtu',
      time: '19.00–21.00',
      description: 'Menyaksikan kesenian Bantengan dan Jaranan yang tumbuh di '
          'tengah masyarakat Kampung Polowijen.',
      imageAsset: 'assets/images/festivalkampung.jpeg',
    ),
    _RoutineActivity(
      name: 'Gladhi Tari Tradisi',
      day: 'Minggu',
      time: '15.00–17.00',
      description: 'Latihan tari tradisional untuk mengenal gerak dan cerita '
          'di balik kesenian Malang.',
      imageAsset: 'assets/images/taritopeng.png',
    ),
    _RoutineActivity(
      name: 'Hasta Karya/Liwetan',
      day: 'Sabtu',
      time: '10.00–12.00',
      description: 'Berkegiatan kreatif dan menikmati kebersamaan melalui '
          'tradisi warga Kampung Polowijen.',
      imageAsset: 'assets/images/mbatik.png',
    ),
    _RoutineActivity(
      name: 'Gladhi Tari Topeng',
      day: 'Minggu',
      time: '15.00–17.00',
      description: 'Belajar dasar tari topeng dan mengenal karakter dalam '
          'kesenian Topeng Malangan.',
      imageAsset: 'assets/images/topeng.jpg',
    ),
    _RoutineActivity(
      name: 'Sinau Budaya',
      day: 'Minggu',
      time: '09.00–11.00',
      description: 'Belajar tradisi, sejarah, dan cerita budaya langsung '
          'bersama warga setempat.',
      imageAsset: 'assets/images/gamelan.png',
    ),
  ];

  static const _cream = Color(0xFFFFF7EA);
  static const _cardBrown = Color(0xFF4B291F);
  static const _terracotta = Color(0xFFA44132);

  int _selectedTab = 0;
  VisitPackage? _selectedPackage;

  String _formatPrice(int price) =>
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
          .format(price);

  @override
  Widget build(BuildContext context) {
    final package = _selectedPackage;
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _cream,
        leading: package == null
            ? null
            : IconButton(
                tooltip: 'Kembali ke paket',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedPackage = null),
              ),
        title: Text(package == null ? 'Paket Kunjungan' : 'Detail Paket'),
      ),
      body:
          package == null ? _buildPackageList() : _buildPackageDetail(package),
    );
  }

  Widget _buildPackageList() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        _buildHero(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: _buildTabs(),
        ),
        if (_selectedTab == 0) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Pilih pengalaman budaya untuk kunjunganmu',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _cardBrown,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              itemCount: _packages.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) =>
                  _buildPackageCard(_packages[index]),
            ),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: _buildRoutineCards(),
          ),
      ],
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC20100C)],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 20,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedTab == 0
                      ? 'Pengenalan Tari\nTopeng Tradisi'
                      : 'Jadwal Kegiatan\nKampung Budaya',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _selectedTab == 0
                      ? 'Warisan leluhur yang penuh makna seni dan sejarah.'
                      : 'Temukan kegiatan budaya rutin bersama warga.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BannerDot(active: true),
                SizedBox(width: 5),
                _BannerDot(active: false),
                SizedBox(width: 5),
                _BannerDot(active: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _cream,
        border: Border.all(color: _cardBrown, width: 1),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          _buildTabButton('Paket Kunjungan', 0),
          _buildTabButton('Jadwal Rutin', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int tabIndex) {
    final isSelected = _selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tabIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? _cardBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : _cardBrown,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(VisitPackage package) {
    return Material(
      color: _cardBrown,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _selectedPackage = package),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                package.imageAsset ?? 'assets/images/login.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 8, 9, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatPrice(package.pricePerPerson)} / orang',
                    style: const TextStyle(
                      color: Color(0xFFEAC47B),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCards() {
    return Column(
      children: [
        for (final activity in _activities) ...[
          _buildRoutineCard(activity),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildRoutineCard(_RoutineActivity activity) {
    return Material(
      color: _cardBrown,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showActivityDetails(activity),
        child: SizedBox(
          height: 94,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    activity.imageAsset,
                    width: 72,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        activity.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFEAC47B),
                          fontSize: 13,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _terracotta,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${activity.day} · ${activity.time}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageDetail(VisitPackage package) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 210,
          width: double.infinity,
          child: Image.asset(
            package.imageAsset ?? 'assets/images/login.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                package.name,
                style: const TextStyle(
                  color: _cardBrown,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatPrice(package.pricePerPerson)} / orang · '
                '${package.duration}',
                style: const TextStyle(color: _cardBrown, fontSize: 13),
              ),
              const Divider(height: 24),
              const Text(
                'Apa yang akan didapatkan?',
                style: TextStyle(
                  color: _cardBrown,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              for (final facility in package.facilities) _buildBullet(facility),
              _buildBullet('Bebas dokumentasi'),
              _buildBullet('Pengalaman budaya bersama warga'),
              const Divider(height: 24),
              const Text(
                'Opsi Tambahan',
                style: TextStyle(
                  color: _cardBrown,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              _buildOption('Tambahan sesi edukasi', true),
              _buildOption('Dokumentasi foto kegiatan', true),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.bookingForm),
                  child: const Text('Pesan Paket'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBullet(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: _cardBrown, fontSize: 13)),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _cardBrown, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, bool included) {
    return Row(
      children: [
        Icon(
          included ? Icons.check_box : Icons.check_box_outline_blank,
          color: included ? AppTheme.maroon : _cardBrown,
          size: 19,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: _cardBrown, fontSize: 12),
        ),
      ],
    );
  }

  Future<void> _showActivityDetails(_RoutineActivity activity) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9BBA5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Detail Kegiatan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _cardBrown,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        activity.imageAsset,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.name,
                            style: const TextStyle(
                              color: _cardBrown,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _detailLine(
                            Icons.calendar_today_outlined,
                            '${activity.day}, ${activity.time}',
                          ),
                          _detailLine(Icons.place_outlined, 'Bebas'),
                          _detailLine(
                            Icons.check_circle_outline,
                            'Gratis dan terbuka untuk umum',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 26),
                const Text(
                  'Tentang Acara',
                  style: TextStyle(
                    color: _cardBrown,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  activity.description,
                  style: const TextStyle(
                    color: _cardBrown,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Fasilitas & Kegiatan',
                  style: TextStyle(
                    color: _cardBrown,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActivityFacility(
                      icon: Icons.account_balance_outlined,
                      label: 'Diskusi\nBudaya',
                    ),
                    _ActivityFacility(
                      icon: Icons.theater_comedy_outlined,
                      label: 'Seni\nTopeng',
                    ),
                    _ActivityFacility(
                      icon: Icons.camera_alt_outlined,
                      label: 'Dokumentasi',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailLine(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: _cardBrown),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _cardBrown, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineActivity {
  const _RoutineActivity({
    required this.name,
    required this.day,
    required this.time,
    required this.description,
    required this.imageAsset,
  });

  final String name;
  final String day;
  final String time;
  final String description;
  final String imageAsset;
}

class _BannerDot extends StatelessWidget {
  const _BannerDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 7 : 5,
      height: active ? 7 : 5,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white60,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ActivityFacility extends StatelessWidget {
  const _ActivityFacility({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Icon(icon, color: _detailBrown, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _detailBrown,
              fontSize: 9,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

const _detailBrown = Color(0xFF4B291F);
