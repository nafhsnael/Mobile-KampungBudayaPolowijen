import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/tour_activity.dart';
import '../../domain/services/tour_guide_planner.dart';

class TourGuideScreen extends StatefulWidget {
  const TourGuideScreen({super.key});

  @override
  State<TourGuideScreen> createState() => _TourGuideScreenState();
}

class _TourGuideScreenState extends State<TourGuideScreen> {
  static const _cream = Color(0xFFFFF8EA);
  static const _brown = Color(0xFF4B291F);
  static const _terracotta = Color(0xFFA44132);
  static const _gold = Color(0xFFC4933F);

  final _visitorController = TextEditingController(text: '3');
  final Set<TourInterest> _selectedInterests = {
    TourInterest.culture,
    TourInterest.arts,
  };
  int _durationHours = 2;
  String? _visitorError;
  TourItinerary? _itinerary;

  @override
  void dispose() {
    _visitorController.dispose();
    super.dispose();
  }

  void _createItinerary() {
    final visitorCount = int.tryParse(_visitorController.text.trim());
    if (visitorCount == null || visitorCount < 1 || visitorCount > 50) {
      setState(() {
        _visitorError = 'Masukkan jumlah pengunjung 1 sampai 50.';
        _itinerary = null;
      });
      return;
    }
    if (_selectedInterests.isEmpty) {
      setState(() {
        _visitorError = null;
        _itinerary = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu minat kunjungan.')),
      );
      return;
    }

    setState(() {
      _visitorError = null;
      _itinerary = TourGuidePlanner.create(
        availableMinutes: _durationHours * 60,
        visitorCount: visitorCount,
        interests: Set.unmodifiable(_selectedInterests),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        title: const Text('AI Personal Tour Guide'),
        backgroundColor: _brown,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _buildIntroduction(),
            const SizedBox(height: 20),
            _buildPreferences(),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('create-itinerary'),
              onPressed: _createItinerary,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Buat Itinerary'),
              style: FilledButton.styleFrom(
                backgroundColor: _terracotta,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            if (_itinerary case final itinerary?) ...[
              const SizedBox(height: 24),
              _buildItinerary(itinerary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFFFD98A)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rencanakan kunjunganmu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Pilih waktu, jumlah pengunjung, dan minat. Pemandu akan menyusun urutan aktivitas budaya Polowijen yang sesuai.',
            style: TextStyle(
              color: Color(0xFFF3E5CC),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Rekomendasi lokal berdasarkan konten KBP',
            style: TextStyle(
              color: Color(0xFFFFD98A),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9DDCB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.schedule_rounded, 'Durasi kunjungan'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _durationHours.toDouble(),
                  min: 1,
                  max: 6,
                  divisions: 5,
                  activeColor: _terracotta,
                  onChanged: (value) => setState(() {
                    _durationHours = value.round();
                    _itinerary = null;
                  }),
                ),
              ),
              SizedBox(
                width: 52,
                child: Text(
                  '$_durationHours jam',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _sectionTitle(Icons.groups_2_outlined, 'Jumlah pengunjung'),
          const SizedBox(height: 8),
          TextField(
            controller: _visitorController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Contoh: 3',
              suffixText: 'orang',
              errorText: _visitorError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onChanged: (_) {
              if (_visitorError != null) {
                setState(() => _visitorError = null);
              }
            },
          ),
          const SizedBox(height: 16),
          _sectionTitle(Icons.favorite_outline, 'Minat kunjungan'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final interest in TourInterest.values)
                FilterChip(
                  label: Text(interest.label),
                  selected: _selectedInterests.contains(interest),
                  selectedColor: const Color(0xFFF4E4C4),
                  checkmarkColor: _terracotta,
                  side: BorderSide(
                    color: _selectedInterests.contains(interest)
                        ? _gold
                        : const Color(0xFFE9DDCB),
                  ),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                    _itinerary = null;
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _terracotta),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: _brown,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildItinerary(TourItinerary itinerary) {
    if (itinerary.steps.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Durasi terlalu singkat untuk aktivitas yang dipilih. Coba tambah durasi kunjungan.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Rencana kunjunganmu',
                style: TextStyle(
                  color: _brown,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${itinerary.visitorCount} orang',
              style: const TextStyle(
                color: _terracotta,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Estimasi aktivitas ${_formatDuration(itinerary.totalMinutes)} dari $_durationHours jam',
          style: const TextStyle(color: Color(0xFF75665A), fontSize: 12),
        ),
        const SizedBox(height: 14),
        for (var index = 0; index < itinerary.steps.length; index++)
          _buildStep(itinerary.steps[index], index),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E4C4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 17, color: _brown),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jadwal aktivitas dapat berubah. Konfirmasi ketersediaan dengan pengelola KBP sebelum berkunjung.',
                  style: TextStyle(
                    color: _brown,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(TourItineraryStep step, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Text(
                  _formatMinute(step.startMinute),
                  style: const TextStyle(
                    color: _terracotta,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 2,
                  height: 44,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: _gold.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9DDCB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: const Color(0xFFF4E4C4),
                    child: Icon(
                      _activityIcon(step.activity.icon),
                      color: _terracotta,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stop ${index + 1} · ${_formatMinute(step.startMinute)}–${_formatMinute(step.endMinute)}',
                          style: const TextStyle(
                            color: _terracotta,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.activity.title,
                          style: const TextStyle(
                            color: _brown,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.activity.description,
                          style: const TextStyle(
                            color: Color(0xFF75665A),
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Durasi ${step.activity.durationMinutes} menit'
                          '${step.travelBeforeMinutes > 0 ? ' · perjalanan ${step.travelBeforeMinutes} menit' : ''}',
                          style: const TextStyle(
                            color: _brown,
                            fontSize: 10,
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
        ],
      ),
    );
  }

  String _formatMinute(int minute) {
    final hours = minute ~/ 60;
    final minutes = minute % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '$remainingMinutes menit';
    if (remainingMinutes == 0) return '$hours jam';
    return '$hours jam $remainingMinutes menit';
  }

  IconData _activityIcon(TourActivityIcon icon) {
    return switch (icon) {
      TourActivityIcon.explore => Icons.explore_outlined,
      TourActivityIcon.mask => Icons.theater_comedy_outlined,
      TourActivityIcon.dance => Icons.accessibility_new_rounded,
      TourActivityIcon.craft => Icons.palette_outlined,
      TourActivityIcon.storefront => Icons.storefront_outlined,
      TourActivityIcon.food => Icons.restaurant_outlined,
    };
  }
}
