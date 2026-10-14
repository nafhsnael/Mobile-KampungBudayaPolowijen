import 'package:flutter/material.dart';

import '../../models/cultural_event.dart';
import '../../utils/url_helper.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({this.onOpenProfile, this.openEventName, super.key});

  final VoidCallback? onOpenProfile;
  final String? openEventName;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  static const _brown = Color(0xFF4B291F);
  static const _gold = Color(0xFFC99B45);
  static const _cream = Color(0xFFFFF7EA);
  static const _terracotta = Color(0xFFA44132);

  static const _events = [
    _EventItem(
      name: CulturalEvent.tariTopengName,
      subtitle: 'Warisan tari topeng khas Malang.',
      description:
          'Saksikan tari Topeng Malangan dengan gerak, iringan musik, dan karakter yang khas. Kenali cerita di balik setiap topeng serta pesan simbolik dalam merawat warisan budaya Polowijen.',
      image: 'assets/images/taritopeng.png',
      date: '25 Okt 2026',
      location: 'Kampung Budaya Polowijen, Malang',
    ),
    _EventItem(
      name: CulturalEvent.festivalBatikName,
      subtitle: 'Ragam batik dan cerita budaya lokal.',
      description:
          'Kenali ragam motif batik dan karya perajin Polowijen. Temukan cerita di balik proses membatik serta semangat warga dalam merawat kerajinan dan budaya lokal.',
      image: 'assets/images/mbatik.png',
      date: '8 Nov 2026',
      location: 'Kampung Budaya Polowijen, Malang',
    ),
    _EventItem(
      name: CulturalEvent.megenganNyadranName,
      subtitle: 'Tradisi syukur dan kebersamaan warga.',
      description:
          'Megengan dan Nyadran menjadi ruang untuk bersyukur, mengenang leluhur, dan mempererat kebersamaan. Kenali tradisi warga Polowijen melalui doa bersama dan sajian khas yang penuh makna.',
      image: 'assets/images/nyadran.png',
      date: '20 Mar 2027',
      location: 'Kampung Budaya Polowijen, Malang',
    ),
  ];

  _EventItem? _selectedEvent;

  void _openEvent(_EventItem event) => setState(() => _selectedEvent = event);

  @override
  void initState() {
    super.initState();
    _selectEvent(widget.openEventName);
  }

  @override
  void didUpdateWidget(covariant EventScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final eventName = widget.openEventName;
    if (eventName == null || eventName == oldWidget.openEventName) return;

    _selectEvent(eventName);
  }

  void _selectEvent(String? eventName) {
    if (eventName == null) return;

    for (final event in _events) {
      if (event.name == eventName) {
        _selectedEvent = event;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: _selectedEvent == null
            ? _buildEventList()
            : _buildEventDetail(_selectedEvent!),
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
            children: [
              _buildIntroductionBanner(),
              const SizedBox(height: 16),
              const Text(
                'Event & Kegiatan',
                style: TextStyle(
                  color: _brown,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Jelajahi ragam budaya dan tradisi Polowijen.',
                style: TextStyle(
                  color: Color(0xFF837469),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kegiatan Terdekat',
                style: TextStyle(
                  color: _brown,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              _buildFeaturedEvent(_events.first),
              const SizedBox(height: 14),
              const Text(
                'Jelajahi Kegiatan',
                style: TextStyle(
                  color: _brown,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              for (final event in _events.skip(1)) ...[
                _buildCompactEvent(event),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 2),
              const Text(
                'Informasi jadwal, lokasi, dan tiket akan dilengkapi setelah tersedia.',
                style: TextStyle(
                  color: Color(0xFF837469),
                  fontSize: 9,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(16, 9, 12, 9),
      decoration: const BoxDecoration(
        color: _terracotta,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kampung Budaya Polowijen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Informasi & Kegiatan Budaya',
                  style: TextStyle(color: Color(0xFFFFE9D2), fontSize: 9),
                ),
              ],
            ),
          ),
          Material(
            color: _cream,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Profil',
              onPressed: widget.onOpenProfile,
              icon: const Icon(Icons.person_outline, color: _terracotta),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 164,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/topeng.jpg', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x11000000), Color(0xCC000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.temple_buddhist,
                          color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Budaya Polowijen',
                        style: TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Pengenalan Budaya\nPolowijen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jelajahi kekayaan budaya, tradisi, dan kegiatan masyarakat Polowijen.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 9,
                      height: 1.3,
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

  Widget _buildFeaturedEvent(_EventItem event) {
    return Material(
      color: _brown,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('featured-event-${event.name}'),
        onTap: () => _openEvent(event),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _eventThumbnail(event.image, 74, 78),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFE3D2C4),
                        fontSize: 9,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _detailButton(event, compact: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactEvent(_EventItem event) {
    return Material(
      color: _brown,
      borderRadius: BorderRadius.circular(13),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('event-${event.name}'),
        onTap: () => _openEvent(event),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: [
              _eventThumbnail(event.image, 64, 72),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      event.name == 'Megengan & Nyadran'
                          ? 'Mengenal tradisi masyarakat dalam menyambut Ramadan dan menghormati leluhur.'
                          : 'Kenali batik khas Polowijen melalui karya dan tradisi lokal.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFE3D2C4),
                        fontSize: 8,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _detailButton(event, compact: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventThumbnail(String path, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _detailButton(_EventItem event, {required bool compact}) {
    return FilledButton.icon(
      key: ValueKey('open-event-${event.name}'),
      onPressed: () => _openEvent(event),
      style: FilledButton.styleFrom(
        backgroundColor: _terracotta,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: compact ? 9 : 13),
        minimumSize: Size(0, compact ? 29 : 38),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          fontSize: compact ? 9 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward, size: 13),
      label: const Text('Lihat Detail'),
    );
  }

  Widget _buildEventDetail(_EventItem event) {
    return Column(
      children: [
        SizedBox(
          height: 225,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(event.image, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x44000000),
                      Colors.transparent,
                      Color(0xFFFFF7EA),
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 10,
                child: Material(
                  color: _cream.withValues(alpha: 0.95),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Kembali ke daftar event',
                    onPressed: () => setState(() => _selectedEvent = null),
                    icon: const Icon(Icons.arrow_back, color: _brown),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 10,
                child: Text(
                  event.name,
                  style: const TextStyle(
                    color: _brown,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
            children: [
              Text(
                event.subtitle,
                style: const TextStyle(
                  color: Color(0xFF75665B),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Tentang Kegiatan',
                style: TextStyle(
                  color: _brown,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                event.description,
                style: const TextStyle(
                  color: Color(0xFF75665B),
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${event.date} · 15.00 WIB',
                      style: const TextStyle(
                        color: Color(0xFF75665B),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Petunjuk lokasi',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _openLocation(event.location),
                    icon: const Icon(Icons.map_outlined, color: _brown),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTicketInformation(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketInformation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kuota',
            style: TextStyle(color: _gold, fontSize: 9),
          ),
          Text(
            '120 Kursi',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
          SizedBox(height: 10),
          Text(
            'Harga Tiket',
            style: TextStyle(color: _gold, fontSize: 9),
          ),
          Text(
            'Rp. 50.000 / Orang',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation(String location) async {
    final launched = await UrlHelper.openMaps(location);
    if (!launched && mounted) {
      UrlHelper.showLaunchError(context, 'Peta tidak dapat dibuka.');
    }
  }
}

class _EventItem {
  const _EventItem({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.date,
    required this.location,
  });

  final String name;
  final String subtitle;
  final String description;
  final String image;
  final String date;
  final String location;
}
