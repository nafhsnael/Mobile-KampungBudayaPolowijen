import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/umkm_product.dart';
import '../../utils/url_helper.dart';

class UmkmScreen extends StatefulWidget {
  const UmkmScreen({super.key});

  @override
  State<UmkmScreen> createState() => _UmkmScreenState();
}

class _UmkmScreenState extends State<UmkmScreen> {
  static const _cream = Color(0xFFFFF8EC);
  static const _brown = Color(0xFF4A281F);
  static const _gold = Color(0xFFC79A48);
  static const _mutedRed = Color(0xFFA64032);
  // Replace this sample contact with the artisans' verified WhatsApp number.
  static const _artisanWhatsAppNumber = '6281234567890';

  static const _products = <UmkmProduct>[
    UmkmProduct(
      name: 'Topeng Malang Panji Asmoro Bangun',
      description: 'Topeng kayu buatan tangan dengan karakter Panji.',
      price: 350000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Topeng Malang Dewi Sekartaji',
      description: 'Topeng kayu ukir dengan detail khas Dewi Sekartaji.',
      price: 375000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Topeng Bapang Malang',
      description: 'Topeng karakter Bapang hasil kerajinan perajin lokal.',
      price: 325000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Kain Batik Tulis Motif Topeng Polowijen',
      description: 'Kain batik tulis bermotif seni topeng Polowijen.',
      price: 450000,
      category: 'Batik',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Kaos Souvenir Kampung Topeng Polowijen',
      description: 'Kaos nyaman dengan ilustrasi Kampung Topeng.',
      price: 95000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Gantungan Kunci Miniatur Topeng Malang',
      description: 'Gantungan kunci mini untuk buah tangan khas Malang.',
      price: 25000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Miniatur Patung Penari Topeng',
      description: 'Miniatur penari topeng sebagai hiasan rumah.',
      price: 185000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Selendang Batik Khas Polowijen',
      description: 'Selendang batik lembut dengan motif tradisional.',
      price: 175000,
      category: 'Batik',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Tas Anyam',
      description: 'Tas anyaman tangan untuk menemani aktivitas harian.',
      price: 145000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=800&q=80',
    ),
    UmkmProduct(
      name: 'Kipas Lukis Motif Topeng',
      description: 'Kipas dekoratif yang dilukis dengan motif topeng.',
      price: 65000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl:
          'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  static const _categories = <_ProductCategory>[
    _ProductCategory(name: 'Kerajinan', icon: Icons.backpack_outlined),
    _ProductCategory(name: 'Batik', icon: Icons.checkroom_outlined),
    _ProductCategory(name: 'Souvenir', icon: Icons.card_giftcard_outlined),
  ];

  final _searchController = TextEditingController();
  final Set<String> _favorites = {};
  String _query = '';
  String? _selectedCategory;
  bool _showAllProducts = false;

  List<UmkmProduct> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == null || product.category == _selectedCategory;
      final normalizedQuery = _query.trim().toLowerCase();
      final matchesSearch = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery) ||
          product.category.toLowerCase().contains(normalizedQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(UmkmProduct product) {
    setState(() {
      if (!_favorites.add(product.name)) {
        _favorites.remove(product.name);
      }
    });
  }

  Future<void> _buyViaWhatsApp(UmkmProduct product) async {
    try {
      final launched = await UrlHelper.openWhatsApp(
        product.whatsappNumber,
        message: 'Halo, saya tertarik ingin membeli produk ${product.name}.',
      );
      if (!launched && mounted) {
        UrlHelper.showLaunchError(
          context,
          'WhatsApp tidak dapat dibuka. Silakan coba lagi.',
        );
      }
    } on PlatformException catch (error) {
      debugPrint('Gagal membuka WhatsApp: $error');
      if (mounted) {
        UrlHelper.showLaunchError(
          context,
          'Terjadi kendala saat membuka WhatsApp. Silakan coba lagi.',
        );
      }
    }
  }

  void _showProduct(UmkmProduct product) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cream,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _ProductImage(
                product: product,
                height: 190,
                borderRadius: BorderRadius.circular(16),
              ),
              const SizedBox(height: 16),
              Text(
                product.category,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                product.name,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(product.description),
              const SizedBox(height: 8),
              Text(
                _formatPrice(product.price),
                style: const TextStyle(
                  color: _brown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  Navigator.pop(sheetContext);
                  await _buyViaWhatsApp(product);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _mutedRed,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Beli via WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                20,
                _showAllProducts ? 8 : MediaQuery.sizeOf(context).height * 0.2,
                20,
                12,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showAllProducts)
                      IconButton(
                        tooltip: 'Kembali ke produk unggulan',
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _showAllProducts = false;
                            _selectedCategory = null;
                            _query = '';
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: _brown,
                        ),
                      ),
                    const Text(
                      'Dukung UMKM Lokal',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Di Kampung Budaya Polowijen',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jelajahi produk unggulan dari pelaku UMKM budaya Kampung Budaya Polowijen. Setiap pembelianmu, ikut melestarikan budaya dan memberdayakan masyarakat.',
                      style: TextStyle(
                        color: Color(0xFF625950),
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                          if (value.isNotEmpty) {
                            _showAllProducts = true;
                          }
                        });
                      },
                      style: const TextStyle(fontSize: 12, color: _brown),
                      decoration: InputDecoration(
                        hintText: 'Cari produk, UMKM, atau kategori...',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAA198),
                          fontSize: 10,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 17,
                          color: Color(0xFFAAA198),
                        ),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Hapus pencarian',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _query = '';
                                    _selectedCategory = null;
                                  });
                                },
                                icon: const Icon(Icons.close, size: 17),
                              ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 11),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (!_showAllProducts) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          for (var index = 0;
                              index < _categories.length;
                              index++) ...[
                            Expanded(
                              child: _CategoryButton(
                                category: _categories[index],
                                selected: _selectedCategory ==
                                    _categories[index].name,
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = _selectedCategory ==
                                            _categories[index].name
                                        ? null
                                        : _categories[index].name;
                                    if (_selectedCategory != null) {
                                      _showAllProducts = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            if (index != _categories.length - 1)
                              const SizedBox(width: 10),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _showAllProducts
                                  ? 'Semua produk'
                                  : 'Produk unggulan',
                              style: const TextStyle(
                                color: _brown,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!_showAllProducts)
                            IconButton(
                              tooltip: 'Lihat semua produk',
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                setState(() => _showAllProducts = true);
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: Color(0xFF786B60),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (!_showAllProducts)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: SizedBox(
                          height: 118,
                          child: _FeaturedProductCard(
                            product: product,
                            isFavorite: _favorites.contains(product.name),
                            onFavoriteTap: () => _toggleFavorite(product),
                            onTap: () => _showProduct(product),
                            onBuyTap: () => _buyViaWhatsApp(product),
                          ),
                        ),
                      );
                    },
                    childCount: _products.take(2).length,
                  ),
                ),
              ),
            if (_showAllProducts)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                sliver: products.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 28),
                          child: Center(
                            child: Text('Produk tidak ditemukan.'),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 302,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _CatalogProductCard(
                              product: product,
                              isFavorite: _favorites.contains(product.name),
                              onFavoriteTap: () => _toggleFavorite(product),
                              onTap: () => _showProduct(product),
                              onBuyTap: () => _buyViaWhatsApp(product),
                            );
                          },
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductCategory {
  const _ProductCategory({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _ProductCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Kategori ${category.name}',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 48,
              decoration: BoxDecoration(
                color:
                    selected ? _UmkmScreenState._gold : const Color(0xFFAD9787),
                borderRadius: BorderRadius.circular(12),
                border: selected
                    ? Border.all(color: const Color(0xFF8D6234), width: 2)
                    : null,
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(color: _UmkmScreenState._brown, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  const _FeaturedProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    required this.onBuyTap,
  });

  final UmkmProduct product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;
  final VoidCallback onBuyTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _UmkmScreenState._brown,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: _ProductImage(
                  product: product,
                  borderRadius: BorderRadius.circular(6),
                  badge: _FavoriteButton(
                    selected: isFavorite,
                    onTap: onFavoriteTap,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Expanded(
                      child: Text(
                        product.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFD8C9BE),
                          fontSize: 8,
                          height: 1.25,
                        ),
                      ),
                    ),
                    Text(
                      _formatPrice(product.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton.icon(
                        onPressed: onBuyTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          textStyle: const TextStyle(fontSize: 9),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.chat_outlined, size: 12),
                        label: const Text('Beli via WA'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogProductCard extends StatelessWidget {
  const _CatalogProductCard({
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    required this.onBuyTap,
  });

  final UmkmProduct product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;
  final VoidCallback onBuyTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 112,
              child: _ProductImage(
                product: product,
                borderRadius: BorderRadius.circular(10),
                badge: _FavoriteButton(
                  selected: isFavorite,
                  onTap: onFavoriteTap,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E9D8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.category,
                  style: const TextStyle(
                    color: _UmkmScreenState._brown,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: onTap,
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _UmkmScreenState._brown,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),
            const Spacer(),
            Text(
              _formatPrice(product.price),
              style: const TextStyle(
                color: _UmkmScreenState._mutedRed,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: FilledButton.icon(
                onPressed: onBuyTap,
                style: FilledButton.styleFrom(
                  backgroundColor: _UmkmScreenState._mutedRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  textStyle: const TextStyle(fontSize: 10),
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(Icons.chat_outlined, size: 14),
                label: const Text('Beli via WA'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 24,
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  foregroundColor: _UmkmScreenState._brown,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(fontSize: 10),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Detail Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
    required this.borderRadius,
    this.height,
    this.badge,
  });

  final UmkmProduct product;
  final BorderRadius borderRadius;
  final double? height;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF1E9DE),
              borderRadius: borderRadius,
            ),
            child: product.imageUrl == null
                ? _imagePlaceholder
                : ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.network(
                      product.imageUrl!,
                      width: double.infinity,
                      height: height,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _imagePlaceholder;
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          _imagePlaceholder,
                    ),
                  ),
          ),
          if (badge != null)
            Positioned(
              top: 4,
              right: 4,
              child: badge!,
            ),
        ],
      ),
    );
  }

  Widget get _imagePlaceholder => Center(
        child: Icon(
          Icons.museum_outlined,
          size: 34,
          color: _UmkmScreenState._brown.withValues(alpha: 0.55),
        ),
      );
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF70463A),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            selected ? Icons.favorite : Icons.favorite_border,
            size: 13,
            color: selected ? const Color(0xFFEF8275) : Colors.white,
          ),
        ),
      ),
    );
  }
}

String _formatPrice(int value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}
