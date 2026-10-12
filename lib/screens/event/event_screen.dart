import 'package:flutter/material.dart';

import '../../models/cultural_event.dart';
import '../../utils/url_helper.dart';
import '../../widgets/content_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  static final _events = [
    CulturalEvent(
      name: 'Pertunjukan Tari Topeng',
      description: 'Pertunjukan seni tari dan topeng Malangan.',
      location: 'Kampung Budaya Polowijen, Malang',
      date: DateTime(2026, 10, 25),
    ),
    CulturalEvent(
      name: 'Workshop Batik',
      description: 'Pengenalan batik dan motif budaya lokal.',
      location: 'Kampung Budaya Polowijen, Malang',
      date: DateTime(2026, 11, 8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event & Agenda')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final event in _events)
            ContentCard(
              title: event.name,
              description:
                  '${event.date.day}/${event.date.month}/${event.date.year} · '
                  '${event.description}',
              leadingIcon: Icons.event_available_outlined,
              trailing: IconButton(
                tooltip: 'Petunjuk lokasi',
                icon: const Icon(Icons.map_outlined),
                onPressed: () async {
                  final launched = await UrlHelper.openMaps(event.location);
                  if (!launched && context.mounted) {
                    UrlHelper.showLaunchError(
                      context,
                      'Peta tidak dapat dibuka.',
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
