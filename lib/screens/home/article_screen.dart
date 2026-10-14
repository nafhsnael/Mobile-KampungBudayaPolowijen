import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  static const _brown = Color(0xFF4B291F);
  static const _gold = Color(0xFFC99B45);
  static const _cream = Color(0xFFFFF7EA);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: _brown,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x294B291F),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Kembali ke Home',
                      onPressed: onBack,
                      icon: const Icon(Icons.home_outlined, color: _brown),
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
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Polowijen',
                          style: TextStyle(
                            color: _gold,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
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
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: _brown),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
              children: [
                _buildIntroduction(),
                _buildHistory(),
                _buildActivities(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      decoration: const BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 116,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/festivalkampung.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                ColoredBox(color: Colors.white.withValues(alpha: 0.34)),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kampung Budaya Polowijen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _brown,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ruang Hidup Budaya Malang',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Text(
              'Kampung Budaya Polowijen berdiri pada 2017 dan menjadi pusat '
              'pelestarian budaya serta kesenian di kawasannya. Gagasan '
              'pendiriannya datang dari Isa Wahyudi, atau Ki Demang, yang '
              'ingin menjaga sejarah budaya lokal Polowijen lewat sebuah '
              'desa wisata. Kampung ini diresmikan Wali Kota Malang pada '
              '2 April 2017. Pengelolaannya dilakukan secara swadaya.',
              style: TextStyle(
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

  Widget _buildHistory() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: _gold,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jejak sejarah di tengah permukiman',
            style: TextStyle(
              color: _brown,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Kampung ini terletak di RW 02 Kelurahan Polowijen, Kecamatan '
            'Blimbing, dan mengusung tema budaya serta tradisi asli Kota '
            'Malang. Di kawasan ini ada Sumur Windu, yang dipercaya sebagai '
            'tempat pemandian Ken Dedes, serta makam Mbah Reni, empu Topeng '
            'Malangan. Peran Mbah Reni dalam seni topeng inilah yang membuat '
            'Polowijen dikenal dengan tradisi wayang topeng.',
            style: TextStyle(color: _brown, fontSize: 12, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildActivities() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: _brown,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yang bisa dilakukan pengunjung',
            style: TextStyle(
              color: _gold,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Kampung ini memiliki beragam kesenian, dari tari, musik, '
            'karawitan, dan dalang, sampai kerajinan topeng dan batik. '
            'Pengunjung tidak hanya menonton. Kamu bisa belajar membuat '
            'topeng Malangan dengan dipandu seniman lokal, lalu lanjut '
            'berlatih tari topeng. Ada pula batik yang dikembangkan di sini, '
            'dari batik tulis sampai ecoprint. Kegiatan lainnya mencakup '
            'pertunjukan wayang topeng, latihan tari mocopat, dan kerajinan '
            'tangan seperti anyaman bambu.',
            style: TextStyle(
              color: Color(0xFFFFF1DE),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}