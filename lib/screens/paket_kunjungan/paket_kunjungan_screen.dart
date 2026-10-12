import 'package:flutter/material.dart';

import '../../config/routes.dart';
import '../../models/visit_package.dart';
import '../../widgets/content_card.dart';
import '../../widgets/primary_button.dart';

class PaketKunjunganScreen extends StatelessWidget {
  const PaketKunjunganScreen({super.key});

  static const _packages = [
    VisitPackage(
      name: 'Workshop Topeng',
      description: 'Belajar mengenal dan mewarnai topeng Malangan',
      pricePerPerson: 50000,
      duration: '2 jam',
      facilities: ['Pemandu', 'Alat dan bahan'],
    ),
    VisitPackage(
      name: 'Jelajah Kampung Budaya',
      description: 'Mengenal sejarah dan budaya Kampung Polowijen',
      pricePerPerson: 35000,
      duration: '1,5 jam',
      facilities: ['Pemandu lokal'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paket Kunjungan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final visitPackage in _packages)
            ContentCard(
              title: visitPackage.name,
              description:
                  '${visitPackage.description}\n${visitPackage.duration} · '
                  'Rp ${visitPackage.pricePerPerson}/orang',
              leadingIcon: Icons.explore_outlined,
            ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Pesan Paket',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.bookingForm);
            },
          ),
        ],
      ),
    );
  }
}
