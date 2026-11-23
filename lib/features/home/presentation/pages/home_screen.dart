import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.userName,
    this.onNavigateToTab,
    this.onOpenArticle,
    this.onOpenExplore,
    this.onOpenEvent,
    super.key,
  });

  final String? userName;
  final ValueChanged<int>? onNavigateToTab;
  final VoidCallback? onOpenArticle;
  final VoidCallback? onOpenExplore;
  final VoidCallback? onOpenEvent;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _brown = Color(0xFF4B291F);
  static const _gold = Color(0xFFC99B45);
  static const _cream = Color(0xFFFFF7EA);
  static const _terracotta = Color(0xFFA44132);

  int _bannerIndex = 0;
  final List<_VisitorReview> _visitorReviews = [
    _VisitorReview(
      name: 'nailaism',
      comment: 'saya suka melakukan aktivitas disini sangat seru',
      rating: 5,
      submittedAt: DateTime(2026, 10, 8),
    ),
    _VisitorReview(
      name: 'zee',
      comment: 'benar benar pengalaman berharga bagi saya',
      rating: 5,
      submittedAt: DateTime(2026, 10, 8),
    ),
  ];

  void _navigateToTab(int index) => widget.onNavigateToTab?.call(index);

  void _showSearch() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cari di Polowijen'),
        content: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Contoh: tari, UMKM, paket',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) {
            Navigator.pop(dialogContext);
            _searchDestination(query);
          },
        ),
      ),
    );
  }

  void _searchDestination(String query) {
    final value = query.toLowerCase();
    if (value.contains('umkm') || value.contains('produk')) {
      _navigateToTab(1);
    } else if (value.contains('paket') || value.contains('kunjungan')) {
      _navigateToTab(2);
    } else if (value.contains('event') ||
        value.contains('tari') ||
        value.contains('budaya')) {
      _navigateToTab(3);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coba cari event, UMKM, atau paket.')),
      );
    }
  }

  Future<void> _showRatingDialog() async {
    var visitorName = '';
    var visitorComment = '';
    var selectedRating = 0;
    String? validationMessage;

    final review = await showDialog<_VisitorReview>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final availableHeight = MediaQuery.sizeOf(context).height -
              MediaQuery.viewInsetsOf(context).vertical -
              32;

          return Dialog(
            backgroundColor: _cream,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                maxHeight: availableHeight,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MASUKAN PENGUNJUNG',
                                style: TextStyle(
                                  color: _terracotta,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Bagaimana pengalamanmu?',
                                style: TextStyle(
                                  color: Color(0xFF302F2B),
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Tutup',
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bagikan penilaianmu untuk membantu kami merawat '
                      'pengalaman di Kampung Budaya Polowijen.',
                      style: TextStyle(
                        color: Color(0xFF796B60),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _ReviewFieldLabel('Nama', optional: true),
                    const SizedBox(height: 6),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) => visitorName = value,
                      decoration: _reviewInputDecoration(hint: 'Nama kamu'),
                    ),
                    const SizedBox(height: 18),
                    const _ReviewFieldLabel('Ulasan'),
                    const SizedBox(height: 6),
                    TextField(
                      minLines: 4,
                      maxLines: 4,
                      maxLength: 500,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) => visitorComment = value,
                      decoration: _reviewInputDecoration(
                        hint: 'Ceritakan pengalamanmu',
                      ).copyWith(
                        counterStyle: const TextStyle(
                          color: Color(0xFF796B60),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          tooltip: 'Beri ${index + 1} bintang',
                          onPressed: () => setDialogState(() {
                            selectedRating = index + 1;
                            validationMessage = null;
                          }),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints.tightFor(
                            width: 52,
                            height: 48,
                          ),
                          iconSize: 36,
                          color: _gold,
                          icon: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                          ),
                        ),
                      ),
                    ),
                    if (validationMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        validationMessage!,
                        style: const TextStyle(
                          color: _terracotta,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _terracotta,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          final comment = visitorComment.trim();
                          if (selectedRating == 0 || comment.isEmpty) {
                            setDialogState(() {
                              validationMessage = selectedRating == 0
                                  ? 'Pilih rating bintang terlebih dahulu.'
                                  : 'Ulasan tidak boleh kosong.';
                            });
                            return;
                          }

                          Navigator.pop(
                            dialogContext,
                            _VisitorReview(
                              name: visitorName.trim().isEmpty
                                  ? 'Pengunjung'
                                  : visitorName.trim(),
                              comment: comment,
                              rating: selectedRating,
                              submittedAt: DateTime.now(),
                            ),
                          );
                        },
                        child: const Text(
                          'Kirim ulasan',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (review == null || !mounted) return;

    setState(() => _visitorReviews.insert(0, review));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terima kasih atas ulasanmu!')),
    );
  }

  void _showReviews() {
    final averageRating = _visitorReviews.isEmpty
        ? 0.0
        : _visitorReviews.fold<double>(
              0,
              (total, review) => total + review.rating,
            ) /
            _visitorReviews.length;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final availableHeight = MediaQuery.sizeOf(dialogContext).height * 0.8;

        return Dialog(
          backgroundColor: _cream,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 620,
              maxHeight: availableHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 14, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SUARA PENGUNJUNG',
                                style: TextStyle(
                                  color: _terracotta,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.8,
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                'Ulasan pengunjung',
                                style: TextStyle(
                                  color: Color(0xFF302F2B),
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${averageRating.toStringAsFixed(1)} / 5 '
                                'dari ${_visitorReviews.length} ulasan',
                                style: const TextStyle(
                                  color: _brown,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Tutup',
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE8DDD0)),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: _visitorReviews.isEmpty
                        ? const Text(
                            'Belum ada ulasan pengunjung.',
                            style: TextStyle(color: _brown),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final columnCount =
                                  constraints.maxWidth > 500 ? 2 : 1;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _visitorReviews.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columnCount,
                                  mainAxisExtent: 132,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemBuilder: (context, index) =>
                                    _buildVisitorReviewCard(
                                  _visitorReviews[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _reviewInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF998C81), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE5D9CB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE5D9CB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: _gold, width: 1.5),
      ),
    );
  }

  Widget _buildVisitorReviewCard(_VisitorReview review) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF302F2B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  review.rating,
                  (_) => const Icon(Icons.star, color: _gold, size: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _formatReviewDate(review.submittedAt),
            style: const TextStyle(color: _brown, fontSize: 9),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              review.comment,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _brown,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatReviewDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildBanner(),
            const SizedBox(height: 16),
            _buildReviewPanel(),
            const SizedBox(height: 14),
            Text(
              'Kegiatan terdekat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _brown,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onOpenEvent ?? () => _navigateToTab(3),
              child: _buildEventCard(),
            ),
            const SizedBox(height: 22),
            Text(
              'Jelajahi Polowijen',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _brown,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            _buildArticleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F4B291F), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Beranda',
              onPressed: () => _navigateToTab(0),
              icon: const Icon(Icons.home_outlined, color: _brown, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KAMPUNG BUDAYA',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  'Polowijen',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: _gold,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Cari',
              onPressed: _showSearch,
              icon: const Icon(Icons.search, color: _brown, size: 21),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    const banners = [
      ('assets/images/gamelan.png', 'Jelajahi Sekarang'),
      ('assets/images/taritopeng.png', 'Kenali Tari Topeng'),
    ];

    return SizedBox(
      height: 176,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: banners.length,
              onPageChanged: (index) => setState(() => _bannerIndex = index),
              itemBuilder: (context, index) => Image.asset(
                banners[index].$1,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: _brown,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.theater_comedy,
                    color: _gold,
                    size: 54,
                  ),
                ),
              ),
            ),
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
              bottom: 10,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: _gold,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 40),
                ),
                onPressed: widget.onOpenExplore ?? () => _navigateToTab(3),
                child: Text(banners[_bannerIndex].$2),
              ),
            ),
            Positioned(
              right: 14,
              bottom: 22,
              child: Row(
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(left: 5),
                    width: index == _bannerIndex ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _bannerIndex ? _gold : Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F4B291F), blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration:
                const BoxDecoration(color: _gold, shape: BoxShape.circle),
            child: const Icon(Icons.star, color: _brown, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'S U A R A  P E N G U N J U',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Bagaimana pengalamanmu?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ceritakan kesanmu tentang Kampung Budaya Polowijen.',
                  style: TextStyle(color: Color(0xFFE0D1C9), fontSize: 9),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: _brown,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 34),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: _showRatingDialog,
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: const Text('Beri rating'),
                      iconAlignment: IconAlignment.end,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 34),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: _showReviews,
                      child: const Text('Lihat Ulasan'),
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

  Widget _buildEventCard() {
    return Container(
      height: 142,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F4B291F), blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/taritopeng.png',
              width: 116,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tari Topeng',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Nikmati pertunjukan tari topeng khas Malang yang menghidupkan kisah dan tradisi Kampung Budaya Polowijen.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFD9C9C0),
                    fontSize: 9,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 28,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _terracotta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: widget.onOpenEvent ?? () => _navigateToTab(3),
                    icon: const Text('Ikuti Acara'),
                    label: const Icon(Icons.chevron_right, size: 17),
                    iconAlignment: IconAlignment.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F4B291F), blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration:
                const BoxDecoration(color: _gold, shape: BoxShape.circle),
            child: const Icon(Icons.article_outlined, color: _brown, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kenali Kampung Budaya Polowijen',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Cari tahu lebih banyak tentang sejarah, tradisi dan kehidupan budaya Malang.',
                  style: TextStyle(
                    color: Color(0xFFD9C9C0),
                    fontSize: 9,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _gold,
                      foregroundColor: _brown,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 32),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: widget.onOpenArticle,
                    icon: const Text('Lihat Artikel'),
                    label: const Icon(Icons.arrow_forward, size: 14),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewFieldLabel extends StatelessWidget {
  const _ReviewFieldLabel(this.label, {this.optional = false});

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          color: Color(0xFF5E554D),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(text: label),
          if (optional)
            const TextSpan(
              text: ' (opsional)',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
        ],
      ),
    );
  }
}

class _VisitorReview {
  const _VisitorReview({
    required this.name,
    required this.comment,
    required this.rating,
    required this.submittedAt,
  });

  final String name;
  final String comment;
  final int rating;
  final DateTime submittedAt;
}
