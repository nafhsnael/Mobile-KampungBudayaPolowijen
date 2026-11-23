import 'package:flutter/material.dart';

import '../pages/tour_guide_screen.dart';

class TourGuideLauncher extends StatelessWidget {
  const TourGuideLauncher({required this.heroTag, super.key});

  final String heroTag;

  static const _gold = Color(0xFFC4933F);
  static const _brown = Color(0xFF4B291F);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      tooltip: 'Buka AI Personal Tour Guide',
      backgroundColor: _gold,
      foregroundColor: _brown,
      onPressed: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const TourGuideScreen(),
          ),
        );
      },
      child: const Icon(Icons.auto_awesome, size: 20),
    );
  }
}
