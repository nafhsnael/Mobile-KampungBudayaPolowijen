import 'package:flutter/material.dart';

import '../../models/cultural_event.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    required this.onBack,
    required this.onOpenEvent,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<String> onOpenEvent;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _brown = Color(0xFF4B291F);
  static const _gold = Color(0xFFC99B45);
  static const _cream = Color(0xFFFFF7EA);
  static const _sand = Color(0xFFF3E5CC);
  static const _terracotta = Color(0xFFA44132);

  static const _categories = [
    _ExploreCategory(
      title: 'Seni & Topeng',
      detailTitle: 'Tentang Topeng Malangan',
      subtitle: 'Warisan budaya yang penuh makna',
      image: 'assets/images/topeng.jpg',
      icon: Icons.theater_comedy,
      description:
          'Topeng Malangan adalah salah satu kesenian khas dari Kampung Budaya Polowijen yang memiliki nilai sejarah, simbolik, dan estetika tinggi. Setiap topeng memiliki karakter dan makna yang berbeda, mulai dari kesatria, raja, hingga tokoh pewayangan. Kesenian ini tidak hanya menjadi bagian dari pertunjukan, tetapi juga mencerminkan nilai-nilai kehidupan masyarakat Malang.',
      facts: [
        ('Jenis Topeng', 'Brahmana, ksatria, raksasa, putri, dll.'),
        ('Bahan', 'Kayu, cat, tradisional, ornamen khas Malang.'),
        ('Makna', 'Simbol karakter, status sosial, dan nilai kehidupan.'),
      ],
      gallery: [
        'assets/images/topeng.jpg',
        'assets/images/taritopeng.png',
        'assets/images/gamelan.png',
      ],
      activity: CulturalEvent.tariTopengName,
      activityEventName: CulturalEvent.tariTopengName,
      activityImage: 'assets/images/taritopeng.png',
    ),
    _ExploreCategory(
      title: 'Tari Tradisional',
      detailTitle: 'Tentang Tari Tradisional',
      subtitle: 'Gerak indah warisan budaya',
      image: 'assets/images/taritopeng.png',
      icon: Icons.accessibility_new,
      description:
          'Tari tradisional merupakan warisan budaya Indonesia yang diwariskan dari generasi ke generasi. Setiap gerakan, kostum, musik, dan properti memiliki makna tersendiri yang mencerminkan nilai, adat, serta identitas masyarakat daerah. Dari gerak yang lembut hingga dinamis, setiap tarian menyimpan cerita dan filosofi yang berharga.',
      facts: [
        ('Jenis Tari', 'Klasik, rakyat, dan tari kreasi.'),
        ('Unsur', 'Gerak, musik, kostum, properti.'),
        ('Makna', 'Cerita, adat, dan nilai budaya.'),
      ],
      gallery: [
        'assets/images/taritopeng.png',
        'assets/images/topeng.jpg',
        'assets/images/gamelan.png',
      ],
      activity: CulturalEvent.tariTopengName,
      activityEventName: CulturalEvent.tariTopengName,
      activityImage: 'assets/images/taritopeng.png',
    ),
    _ExploreCategory(
      title: 'Batik & Kerajinan',
      detailTitle: 'Batik & Kerajinan Polowijen',
      subtitle: 'Karya tangan dengan cerita lokal',
      image: 'assets/images/mbatik.png',
      icon: Icons.local_florist_outlined,
      description:
          'Batik dan kerajinan di Polowijen tumbuh dari keterampilan warga yang diwariskan dan dikembangkan bersama. Motif, bahan, serta proses pembuatannya menghadirkan cerita tentang lingkungan dan kehidupan masyarakat setempat.',
      facts: [
        ('Kegiatan', 'Batik tulis dan ecoprint.'),
        ('Bahan', 'Kain, malam, dan pewarna.'),
        ('Karya', 'Motif yang terinspirasi budaya lokal.'),
      ],
      gallery: [
        'assets/images/mbatik.png',
        'assets/images/festivalkampung.jpeg',
        'assets/images/gamelan.png',
      ],
      activity: CulturalEvent.festivalBatikName,
      activityEventName: CulturalEvent.festivalBatikName,
      activityImage: 'assets/images/mbatik.png',
    ),
    _ExploreCategory(
      title: 'Pengalaman Budaya',
      detailTitle: 'Pengalaman Budaya Polowijen',
      subtitle: 'Belajar langsung bersama warga',
      image: 'assets/images/festivalkampung.jpeg',
      icon: Icons.groups,
      description:
          'Kunjungan ke Kampung Budaya Polowijen mengajak pengunjung mengenal keseharian warga, tradisi, dan kesenian secara langsung. Berbincang dengan pelaku budaya membuat setiap pengalaman terasa lebih dekat dan bermakna.',
      facts: [
        ('Aktivitas', 'Jelajah kampung dan kesenian.'),
        ('Pendamping', 'Pelaku budaya dan warga lokal.'),
        ('Suasana', 'Belajar, berinteraksi, dan berkarya.'),
      ],
      gallery: [
        'assets/images/festivalkampung.jpeg',
        'assets/images/gamelan.png',
        'assets/images/mbatik.png',
      ],
      activity: CulturalEvent.megenganNyadranName,
      activityEventName: CulturalEvent.megenganNyadranName,
      activityImage: 'assets/images/nyadran.png',
    ),
  ];

  _ExploreCategory? _selectedCategory;

  Future<void> _showSearch() async {
    final query = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cari budaya'),
        content: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Topeng, tari, batik...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );

    if (query == null || !mounted) return;
    final normalizedQuery = query.toLowerCase().trim();
    final match = _categories.where((category) {
      return category.title.toLowerCase().contains(normalizedQuery) ||
          category.detailTitle.toLowerCase().contains(normalizedQuery);
    });
    if (match.isNotEmpty) {
      setState(() => _selectedCategory = match.first);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori budaya tidak ditemukan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _selectedCategory;
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(category),
            Expanded(
              child: category == null
                  ? _buildCategoryList()
                  : _buildCategoryDetail(category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(_ExploreCategory? category) {
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
      decoration: const BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        children: [
          Material(
            color: _cream,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: category == null ? 'Kembali ke Home' : 'Kembali',
              onPressed: category == null
                  ? widget.onBack
                  : () => setState(() => _selectedCategory = null),
              icon: const Icon(Icons.arrow_back, color: _brown, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == null ? 'Jelajahi Polowijen' : category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _gold,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category == null
                      ? 'Temukan pesona budaya lokal Malang'
                      : category.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _cream, fontSize: 9),
                ),
              ],
            ),
          ),
          Material(
            color: _gold,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Cari budaya',
              onPressed: _showSearch,
              icon: const Icon(Icons.search, color: _brown, size: 21),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 128,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/taritopeng.png', fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xCC4B291F), Colors.transparent],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 210,
                      child: Text(
                        'Cerita budaya hidup di setiap langkah.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Mau menjelajahi apa?',
          style: TextStyle(
            color: _brown,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(_ExploreCategory category) {
    return Material(
      color: _sand,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('explore-category-${category.title}'),
        onTap: () => setState(() => _selectedCategory = category),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(category.image, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              child: Row(
                children: [
                  Icon(category.icon, color: _brown, size: 17),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _brown,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: _brown, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDetail(_ExploreCategory category) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 126,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(category.image, fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x99000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 9,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _brown.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon, color: _gold, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          category.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
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
        const SizedBox(height: 12),
        Text(
          category.detailTitle,
          style: const TextStyle(
            color: _brown,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          category.description,
          style: const TextStyle(
            color: Color(0xFF75665B),
            fontSize: 10,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 11),
        _buildFacts(category),
        const SizedBox(height: 10),
        const Text(
          'Galeri',
          style: TextStyle(
            color: _brown,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 72,
          child: Row(
            children: [
              for (var index = 0; index < category.gallery.length; index++) ...[
                if (index > 0) const SizedBox(width: 7),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      category.gallery[index],
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildActivity(category),
      ],
    );
  }

  Widget _buildFacts(_ExploreCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        color: _sand,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var index = 0; index < category.facts.length; index++) ...[
            if (index > 0)
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                color: const Color(0xFFE2D1B5),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        index == 0
                            ? category.icon
                            : index == 1
                                ? Icons.auto_awesome
                                : Icons.place,
                        color: _brown,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          category.facts[index].$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _brown,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.facts[index].$2,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF75665B),
                      fontSize: 7,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivity(_ExploreCategory category) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _sand,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 13,
                backgroundColor: _brown,
                child: Icon(Icons.calendar_month, color: _cream, size: 15),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aktivitas Terkait',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Ikuti kegiatan menarik seputar budaya.',
                      style: TextStyle(color: Color(0xFF75665B), fontSize: 8),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _brown, size: 18),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    category.activityImage,
                    width: 68,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Pertunjukan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        category.activity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _brown,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        '12 Okt 2026 · 15.00 WIB',
                        style: TextStyle(color: Color(0xFF75665B), fontSize: 7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: () =>
                      widget.onOpenEvent(category.activityEventName),
                  style: FilledButton.styleFrom(
                    backgroundColor: _brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 26),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 7),
                  ),
                  child: const Text('Lihat Detail'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCategory {
  const _ExploreCategory({
    required this.title,
    required this.detailTitle,
    required this.subtitle,
    required this.image,
    required this.icon,
    required this.description,
    required this.facts,
    required this.gallery,
    required this.activity,
    required this.activityEventName,
    required this.activityImage,
  });

  final String title;
  final String detailTitle;
  final String subtitle;
  final String image;
  final IconData icon;
  final String description;
  final List<(String, String)> facts;
  final List<String> gallery;
  final String activity;
  final String activityEventName;
  final String activityImage;
}
