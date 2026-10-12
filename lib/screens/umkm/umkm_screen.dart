import 'package:flutter/material.dart';

import '../../models/umkm_product.dart';

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

  static const _products = <UmkmProduct>[
    UmkmProduct(
      name: 'Tas Anyam',
      description: 'Tas anyaman mendong untuk aktivitas harian.',
      price: 25000,
      category: 'Kerajinan',
    ),
    UmkmProduct(
      name: 'Batik Tulis',
      description: 'Batik tulis dengan ragam motif budaya lokal.',
      price: 25000,
      category: 'Batik',
    ),
    UmkmProduct(
      name: 'Topeng',
      description: 'Topeng karakter khas Malangan.',
      price: 25000,
      category: 'Kerajinan',
    ),
    UmkmProduct(
      name: 'Ecoprint',
      description: 'Kain dengan motif alami dari dedaunan.',
      price: 25000,
      category: 'Batik',
    ),
    UmkmProduct(
      name: 'Anyaman',
      description: 'Kerajinan tangan lokal yang unik.',
      price: 25000,
      category: 'Kerajinan',
    ),
    UmkmProduct(
      name: 'Suvenir',
      description: 'Buah tangan untuk kenang-kenangan.',
      price: 25000,
      category: 'Suvenir',
    ),
    UmkmProduct(
      name: 'Jajanan',
      description: 'Camilan tradisional khas daerah.',
      price: 25000,
      category: 'Kuliner',
    ),
    UmkmProduct(
      name: 'Minuman',
      description: 'Minuman segar tradisional.',
      price: 25000,
      category: 'Kuliner',
    ),
  ];

  static const _categories = <_ProductCategory>[
    _ProductCategory(name: 'Kerajinan', icon: Icons.backpack_outlined),
    _ProductCategory(name: 'Batik', icon: Icons.checkroom_outlined),
    _ProductCategory(name: 'Suvenir', icon: Icons.card_giftcard_outlined),
    _ProductCategory(name: 'Kuliner', icon: Icons.restaurant_outlined),
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
                onPressed: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content:
                            Text('${product.name} ditambahkan ke keranjang'),
                      ),
                    );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _mutedRed,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Tambah ke keranjang'),
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
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.67,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return _CatalogProductCard(
                              product: product,
                              isFavorite: _favorites.contains(product.name),
                              onFavoriteTap: () => _toggleFavorite(product),
                              onTap: () => _showProduct(product),
                            );
                          },
                          childCount: products.length,
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
  });

  final UmkmProduct product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

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
  });

  final UmkmProduct product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _UmkmScreenState._brown,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _ProductImage(
                  borderRadius: BorderRadius.circular(6),
                  badge: _FavoriteButton(
                    selected: isFavorite,
                    onTap: onFavoriteTap,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                flex: 2,
                child: Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFD8C9BE),
                    fontSize: 8,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatPrice(product.price),
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
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.borderRadius,
    this.height,
    this.badge,
  });

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
              color: Colors.white,
              borderRadius: borderRadius,
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
  final digits = value.toString();
  final result = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      result.write('.');
    }
    result.write(digits[index]);
  }
  return 'Rp${result.toString()}';
}
