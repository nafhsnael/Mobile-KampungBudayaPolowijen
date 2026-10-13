# 🎭 Polowijen Cultural & Tourism Mobile App

Aplikasi mobile berbasis **Flutter** untuk mendukung pariwisata dan edukasi budaya di **Kampung Wisata Topeng Polowijen**, Malang. Proyek ini dikembangkan sebagai bagian dari Tugas Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile[cite: 2].

---

## 👥 Anggota Kelompok

<<<<<<< HEAD
| No | Nama Mahasiswa | NIM |
| :---: | :--- | :---: |
| 1. | **Nafhisa Nailah Husnah** | 253140707111072 |
| 2. | **Kasiva Imtiyas Zaidah Iftinan** | 253140707111085 | 
| 3. | **[Shinta Rahmawati** | 253140707111025 | 
=======


---

## 📌 Deskripsi Proyek

Aplikasi mobile Polowijen (sisi *User*) bertujuan untuk memberikan pengalaman interaktif bagi wisatawan dalam mengeksplorasi kebudayaan Topeng Malang, membeli produk kerajinan UMKM lokal, melakukan reservasi paket kunjungan/workshop, serta memantau jadwal acara kebudayaan[cite: 4].

### Materi Perkuliahan yang Diterapkan:
* **Widget Interaction & UI Composition**: Penggunaan Card, GridView, ListTile, Custom Buttons, InkWell, dan BottomNavigationBar[cite: 1, 4].
* **Navigation & Routing**: Implementasi Named Routes dan Bottom Navigation Shell untuk perpindahan antar halaman[cite: 4].
* **Form & Input Validation**: Penggunaan `Form`, `GlobalKey<FormState>`, dan `TextFormField` beserta aturan validator pada Login, Register, dan Reservasi Paket[cite: 1, 4].
* **Package & Plugin Integration**:
  * `google_fonts`: Konsistensi tipografi UI modern[cite: 1, 4].
  * `intl`: Format nilai mata uang `Rp` dan tanggal[cite: 1, 4].
  * `shared_preferences`: Penyimpanan sesi login dan preferensi lokal[cite: 1, 4].
  * `url_launcher`: Integrasi tautan luar ke Google Maps (Lokasi) dan WhatsApp (Pengrajin/CS)[cite: 1, 4].

---

## 📱 Fitur & Halaman Utama (7 Screens)

1. **Login Page**: Autentikasi masuk akun pengguna dengan validasi[cite: 4].
2. **Register Page**: Pendaftaran akun pengguna baru[cite: 4].
3. **Home Page**: Dashboard utama berisi banner informasi, rekomendasi, dan quick menu[cite: 4].
4. **UMKM Page**: Katalog produk kerajinan topeng & batik lokal terhubung ke WhatsApp via `url_launcher`[cite: 4].
5. **Paket Kunjungan Page**: Daftar paket wisata/workshop edukasi dilengkapi Form Reservasi Tiket[cite: 4].
6. **Event Page**: Jadwal & informasi agenda pertunjukan seni kebudayaan[cite: 4].
7. **Profile Page**: Informasi pengguna, pengaturan akun, dan fungsi Logout via `shared_preferences`[cite: 4].

---

## 🔮 Rencana Fitur Masa Depan (AI Vision Feature)

* **Nama Fitur**: **AI Topeng Malang Scanner** *(Cultural Artifact Recognition)*[cite: 2, 4]
* **Deskripsi**: Fitur berbasis Computer Vision dan Image Classification (TensorFlow Lite)[cite: 4]. Wisatawan dapat memindai/mengambil foto topeng fisik di museum/kampung wisata untuk mendapatkan penjelasan otomatis mengenai sejarah, filosofi tokoh, serta tarian tari topeng yang sesuai[cite: 4].

---

## 🛠️ Package & Library yang Digunakan

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  intl: ^0.19.0
  shared_preferences: ^2.2.2
<<<<<<< HEAD
  url_launcher: ^6.2.5
=======
