import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/url_helper.dart';
import '../../domain/entities/umkm_product.dart';

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
      imageUrl: 'assets/images/images.png',
    ),
    UmkmProduct(
      name: 'Topeng Malang Dewi Sekartaji',
      description: 'Topeng kayu ukir dengan detail khas Dewi Sekartaji.',
      price: 375000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/topeng.jpg',
    ),
    UmkmProduct(
      name: 'Topeng Bapang Malang',
      description: 'Topeng karakter Bapang hasil kerajinan perajin lokal.',
      price: 325000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/taritopeng.png',
    ),
    UmkmProduct(
      name: 'Kain Batik Tulis Motif Topeng Polowijen',
      description: 'Kain batik tulis bermotif seni topeng Polowijen.',
      price: 450000,
      category: 'Batik',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/mbatik.png',
    ),
    UmkmProduct(
      name: 'Kaos Souvenir Kampung Topeng Polowijen',
      description: 'Kaos nyaman dengan ilustrasi Kampung Topeng.',
      price: 95000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/festivalkampung.jpeg',
    ),
    UmkmProduct(
      name: 'Gantungan Kunci Miniatur Topeng Malang',
      description: 'Gantungan kunci mini untuk buah tangan khas Malang.',
      price: 25000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/images.png',
    ),
    UmkmProduct(
      name: 'Miniatur Patung Penari Topeng',
      description: 'Miniatur penari topeng sebagai hiasan rumah.',
      price: 185000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/taritopeng.png',
    ),
    UmkmProduct(
      name: 'Selendang Batik Khas Polowijen',
      description: 'Selendang batik lembut dengan motif tradisional.',
      price: 175000,
      category: 'Batik',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/mbatik.png',
    ),
    UmkmProduct(
      name: 'Tas Anyam',
      description: 'Tas anyaman tangan untuk menemani aktivitas harian.',
      price: 145000,
      category: 'Kerajinan',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/masak.webp',
    ),
    UmkmProduct(
      name: 'Kipas Lukis Motif Topeng',
      description: 'Kipas dekoratif yang dilukis dengan motif topeng.',
      price: 65000,
      category: 'Souvenir',
      whatsappNumber: _artisanWhatsAppNumber,
      imageUrl: 'assets/images/images.png',
    ),
  ];

  static const _wishlistKey = 'umkmWishlist';
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
  bool _showWishlist = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

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

  Future<void> _loadFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    final savedNames = preferences.getStringList(_wishlistKey) ?? const [];
    if (!mounted) return;
    setState(() {
      _favorites.addAll(
        savedNames.where(
          (name) => _products.any((product) => product.name == name),
        ),
      );
    });
  }

  Future<void> _toggleFavorite(UmkmProduct product) async {
    final wasFavorite = _favorites.contains(product.name);
    setState(() {
      if (wasFavorite) {
        _favorites.remove(product.name);
      } else {
        _favorites.add(product.name);
      }
    });

    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setStringList(
      _wishlistKey,
      _favorites.toList(),
    );
    if (!saved && mounted) {
      setState(() {
        if (wasFavorite) {
          _favorites.add(product.name);
        } else {
          _favorites.remove(product.name);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wishlist gagal disimpan.')),
      );
    }
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
    final favoriteProducts = _products
        .where((product) => _favorites.contains(product.name))
        .toList();

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        bottom: false,
        child: _showWishlist
            ? _WishlistScreen(
                products: favoriteProducts,
                onBack: () => setState(() => _showWishlist = false),
                onFavoriteTap: _toggleFavorite,
                onProductTap: _showProduct,
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      _showAllProducts
                          ? 8
                          : MediaQuery.sizeOf(context).height * 0.2,
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
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Dukung UMKM Lokal',
                                  style: TextStyle(
                                    color: _brown,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Buka wishlist',
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    setState(() => _showWishlist = true),
                                icon: Badge(
                                  isLabelVisible: _favorites.isNotEmpty,
                                  label: Text('${_favorites.length}'),
                                  child: const Icon(
                                    Icons.favorite_border,
                                    color: _brown,
                                  ),
                                ),
                              ),
                            ],
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
                                          _selectedCategory =
                                              _selectedCategory ==
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
                                    isFavorite:
                                        _favorites.contains(product.name),
                                    onFavoriteTap: () =>
                                        _toggleFavorite(product),
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
                    child: product.imageUrl!.startsWith('assets/')
                        ? Image.asset(
                            product.imageUrl!,
                            width: double.infinity,
                            height: height,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _imagePlaceholder,
                          )
                        : Image.network(
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
    return Tooltip(
      message: selected ? 'Hapus dari wishlist' : 'Simpan ke wishlist',
      child: Material(
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
      ),
    );
  }
}

class _WishlistScreen extends StatefulWidget {
  const _WishlistScreen({
    required this.products,
    required this.onBack,
    required this.onFavoriteTap,
    required this.onProductTap,
  });

  final List<UmkmProduct> products;
  final VoidCallback onBack;
  final ValueChanged<UmkmProduct> onFavoriteTap;
  final ValueChanged<UmkmProduct> onProductTap;

  @override
  State<_WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<_WishlistScreen> {
  static const _brown = _UmkmScreenState._brown;
  final _searchController = TextEditingController();
  String _query = '';

  List<UmkmProduct> get _filteredProducts {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.products;
    return widget.products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            tooltip: 'Kembali ke katalog UMKM',
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: _brown),
          ),
          const Text(
            'Wishlist',
            style: TextStyle(
              color: _brown,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Produk favoritmu tersimpan di sini.',
            style: TextStyle(color: Color(0xFF74685E), fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: const TextStyle(fontSize: 12, color: _brown),
            decoration: InputDecoration(
              hintText: 'Cari produk wishlist...',
              hintStyle:
                  const TextStyle(color: Color(0xFFAAA198), fontSize: 11),
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Hapus pencarian wishlist',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close, size: 17),
                    ),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${widget.products.length} produk tersimpan',
            style: const TextStyle(
              color: _brown,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 48,
                          color: _brown.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.products.isEmpty
                              ? 'Wishlist kamu masih kosong.'
                              : 'Produk tidak ditemukan.',
                          style: const TextStyle(color: Color(0xFF74685E)),
                        ),
                        if (widget.products.isEmpty) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Simpan produk dengan mengetuk ikon hati.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF8C8178),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 230,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _WishlistProductCard(
                        product: product,
                        onTap: () => widget.onProductTap(product),
                        onFavoriteTap: () => widget.onFavoriteTap(product),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Ketuk ikon hati untuk menghapus produk dari wishlist.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8C8178), fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  const _WishlistProductCard({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final UmkmProduct product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 112,
                child: _ProductImage(
                  product: product,
                  borderRadius: BorderRadius.circular(10),
                  badge: _FavoriteButton(selected: true, onTap: onFavoriteTap),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF8B6B4C),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
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
              const Spacer(),
              Text(
                _formatPrice(product.price),
                style: const TextStyle(
                  color: _UmkmScreenState._mutedRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
