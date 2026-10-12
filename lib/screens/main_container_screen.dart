import 'package:flutter/material.dart';

import '../screens/event/event_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/paket_kunjungan/paket_kunjungan_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/umkm/umkm_screen.dart';
import '../utils/session_storage.dart';

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({
    this.initialIndex = 0,
    this.userName,
    super.key,
  }) : assert(initialIndex >= 0 && initialIndex < 5);

  final int initialIndex;
  final String? userName;

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  late int _selectedIndex = widget.initialIndex;
  String? _userName;

  static const _destinations = [
    _TabDestination(
        label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home),
    _TabDestination(
        label: 'UMKM',
        icon: Icons.shopping_cart_outlined,
        selectedIcon: Icons.shopping_cart),
    _TabDestination(
        label: 'Paket',
        icon: Icons.groups_outlined,
        selectedIcon: Icons.groups),
    _TabDestination(
        label: 'Event', icon: Icons.event_outlined, selectedIcon: Icons.event),
    _TabDestination(
        label: 'Profil',
        icon: Icons.person_outline,
        selectedIcon: Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    if (_userName == null) {
      _loadUserName();
    }
  }

  Future<void> _loadUserName() async {
    final userName = await SessionStorage.getUserName();
    if (mounted) {
      setState(() => _userName = userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(userName: _userName),
      const UmkmScreen(),
      const PaketKunjunganScreen(),
      const EventScreen(),
      ProfileScreen(userName: _userName),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          for (final destination in _destinations)
            BottomNavigationBarItem(
              icon: Icon(destination.icon),
              activeIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

class _TabDestination {
  const _TabDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
