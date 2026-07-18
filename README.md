# Nada Cilik

Aplikasi pembelajaran musik untuk anak-anak, dibangun menggunakan Flutter dan Firebase. Nada Cilik menyediakan koleksi lagu musik dan edukasi yang dapat diputar langsung, dilengkapi fitur favorit, pengaturan waktu tidur otomatis, dan player audio dengan mini player yang persisten di seluruh halaman.

## Download



Unduh APK terbaru langsung dari [halaman Releases], lalu instal di perangkat Android Anda (pastikan opsi "Install from unknown sources" sudah diaktifkan di pengaturan perangkat).

> **Catatan:** Link download di atas hanya akan berfungsi setelah file APK diunggah ke bagian [Releases] repo ini dengan nama file `app-release.apk`.

## Tentang Aplikasi

Nada Cilik dirancang untuk membantu anak-anak belajar sambil mendengarkan musik dengan antarmuka yang ramah anak — penuh warna, ikon besar, dan navigasi yang sederhana.

## Fitur Utama

- **Login & Register** — sistem autentikasi sederhana dengan validasi input
- **Edit Profil** — ubah username dan password
- **Musik** — koleksi lagu musik anak dengan pencarian
- **Edukasi** — koleksi lagu edukasi anak dengan pencarian
- **Favorit** — simpan dan kelola lagu favorit
- **Player Audio** — streaming audio dengan kontrol play/pause/next/previous dan auto-next
- **Mini Player** — pemutar mini yang tetap muncul di semua halaman saat lagu sedang diputar
- **Pengaturan Tidur (Sleep Timer)** — atur waktu otomatis musik berhenti, dengan notifikasi peringatan
- **Lagu Pilihan Hari Ini** — banner rekomendasi lagu di halaman utama
- **Deteksi Koneksi Internet** — notifikasi saat aplikasi tidak terhubung ke internet

## Teknologi yang Digunakan

| Teknologi | Kegunaan |
| --- | --- |
| [Flutter](https://flutter.dev) | Framework utama pengembangan aplikasi |
| [Firebase Firestore](https://firebase.google.com/products/firestore) | Database untuk data pengguna, lagu, dan favorit |
| [just_audio](https://pub.dev/packages/just_audio) | Pemutaran audio streaming |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | Caching gambar dari URL |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Penyimpanan status login lokal |

## Struktur Proyek

```
lib/
├── pages/
│   ├── login_page.dart          # Halaman login & register
│   ├── home_page.dart           # Halaman utama dengan grid fitur
│   ├── musik_page.dart          # Daftar lagu musik
│   ├── edukasi_page.dart        # Daftar lagu edukasi
│   ├── favorit_page.dart        # Daftar lagu favorit
│   ├── sleep_page.dart          # Pengaturan waktu tidur
│   ├── player_page.dart         # Pemutar audio utama
│   ├── editprofil_page.dart     # Edit profil pengguna
│   ├── mini_player_widget.dart  # Widget mini player global
│   ├── audio_manager.dart       # Singleton pengelola audio
│   ├── sleep_manager.dart       # Singleton pengelola sleep timer
│   ├── connectivity_helper.dart # Pengecekan koneksi internet
│   └── snackbar_helper.dart     # Notifikasi custom
├── firebase_options.dart
└── main.dart
```

## Cara Menjalankan Proyek

### Prasyarat

- Flutter SDK 3.11 atau lebih baru (cek dengan `flutter --version`)
- Akun Firebase dengan project aktif
- Editor (VS Code direkomendasikan)

### Langkah-langkah

1. Clone repository ini

```
git clone https://github.com/dheamuhamadfaisal/nadacilik.git
cd nadacilik
```

2. Install dependencies

```
flutter pub get
```

3. Hubungkan ke Firebase (jika belum terhubung)

```
dart pub global activate flutterfire_cli
flutterfire configure
```

4. Jalankan aplikasi

```
flutter run -d chrome
```

atau untuk Android:

```
flutter run
```

### Build APK

```
flutter clean
flutter pub get
flutter build apk --release
```

File APK akan tersedia di `build/app/outputs/flutter-apk/app-release.apk` — file inilah yang dibagikan ke dosen/penguji untuk diinstal langsung di perangkat Android tanpa perlu menjalankan source code, atau bisa diunggah ke bagian [Releases](https://github.com/dheamuhamadfaisal/nadacilik/releases) repo ini agar bisa diunduh publik.

## Struktur Database (Firestore)

| Collection | Keterangan |
| --- | --- |
| `users` | Data login pengguna (username, password) |
| `lagu` | Katalog lagu (judul, artis, audio_url, cover_url, tipe, featured) |
| `favorit` | Lagu yang disimpan pengguna sebagai favorit |

## Pengujian (Testing)

Aplikasi telah diuji pada lingkungan berikut:

| Platform | Perangkat | Status |
| --- | --- | --- |
| Web | Chrome (localhost:3000) | ✅ Berjalan normal |
| Android Emulator | Pixel API 34 | ✅ Berjalan normal |
| Android Fisik | *(isi merk/tipe HP yang dipakai uji coba)* | ✅ Berjalan normal |

**Alur pengujian yang dilakukan:**

- Register akun baru → Login → masuk Home
- Navigasi ke seluruh fitur: Musik, Edukasi, Favorit, Sleep Timer
- Tambah & hapus lagu dari Favorit
- Putar lagu, pindah halaman, pastikan mini player tetap berjalan
- Aktifkan Sleep Timer dan pastikan aplikasi tertutup otomatis saat waktu habis
- Edit profil dan logout
- Uji kondisi tanpa koneksi internet (notifikasi muncul dengan benar)

## Kendala & Solusi

Berikut beberapa kendala utama yang ditemukan selama pengembangan beserta solusinya:

| Kendala | Penyebab | Solusi |
| --- | --- | --- |
| Audio berhenti saat berpindah halaman | `AudioPlayer` di-dispose setiap halaman ditutup | Buat `AudioManager` sebagai singleton agar audio tetap berjalan di background |
| Sleep timer reset saat keluar dari halaman Tidur | Timer disimpan di state widget yang ikut ter-dispose | Pindahkan logic timer ke `SleepManager` singleton, independen dari lifecycle halaman |
| Tombol *next/previous* di mini player tidak berfungsi | Mini player tidak tahu playlist & index lagu yang aktif | Tambahkan `currentPlaylist`, `currentIndex`, dan stream `laguChangedStream` di `AudioManager` |
| Notifikasi (SnackBar) tetap muncul setelah pindah halaman | `ScaffoldMessenger` bawaan Flutter tidak otomatis hilang saat navigasi | Buat `snackbar_helper.dart` dengan notifikasi custom yang konsisten di semua halaman |
| Tombol terlihat bergaris meski sudah diberi warna | Salah memakai `OutlinedButton` alih-alih `ElevatedButton` | Ganti seluruh tombol solid menjadi `ElevatedButton` |
| Dialog konfirmasi tampilannya polos | Memakai `AlertDialog` bawaan tanpa kustomisasi | Buat dialog custom dengan ikon bulat, rounded corner, dan warna senada aplikasi |

## Screenshot

| Login | Registrasi | Edit Profil |
| --- | --- | --- |
| [![Login](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Login.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Login.jpg) | [![Registrasi](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Registrasi.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Registrasi.jpg) | [![Edit Profil](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Edit_Profil.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Edit_Profil.jpg) |

| Favorit | Pengaturan Tidur | Edukasi |
| --- | --- | --- |
| [![Favorit](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Favorit.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Favorit.jpg) | [![Pengaturan Tidur](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Pengaturan_Tidur.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Pengaturan_Tidur.jpg) | [![Edukasi](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Edukasi.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Edukasi.jpg) |

| Musik | Player Edukasi | Player Musik |
| --- | --- | --- |
| [![Musik](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Musik.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Musik.jpg) | [![Player Edukasi](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Play_Edukasi.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Play_Edukasi.jpg) | [![Player Musik](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Play_Musik.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Play_Musik.jpg) |

| Beranda |
| --- |
| [![Beranda](https://github.com/dheamuhamadfaisal/nadacilik/raw/main/screenshots/Beranda.jpg)](/dheamuhamadfaisal/nadacilik/blob/main/screenshots/Beranda.jpg) |

## Pengembang

Dikembangkan sebagai proyek tugas akhir mata kuliah Pemrograman Mobile.

## Lisensi

Proyek ini dibuat untuk keperluan akademik.

---

© 2026 Nada Cilik. Dibuat dengan Flutter & Firebase.
