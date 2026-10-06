# Laporan Praktikum Basis Data - Pertemuan 01
**Nama:** Syifa   **NIM:** 2301010105   **Kelas:** Ilmu Komputer A   **Tanggal:** 6 Oktober 2026

## 1. Tujuan Praktikum
1. Menjalankan dan menghentikan layanan MariaDB melalui XAMPP Control Panel serta membaca status dan port layanan[cite: 28].
2. Terhubung ke server MariaDB melalui klien baris perintah (CLI) dan phpMyAdmin serta memahami perbedaan keduanya[cite: 28].
3. Mengamankan akun `root` dengan password dan membuat akun kerja terbatas (*least privilege*) untuk satu basis data[cite: 28, 31].
4. Membuat basis data pertama dan mencatat riwayat pekerjaan ke repositori Git yang terhubung ke GitHub[cite: 28].

## 2. Ringkasan Dasar Teori
DBMS (Database Management System) adalah perangkat lunak yang mengelola penyimpanan, keamanan, dan pengaksesan data secara terorganisasi[cite: 28]. MariaDB menggunakan arsitektur klien-server di mana layanan server (`mysqld`) berjalan di latar belakang pada port TCP 3306 untuk mendengarkan perintah dari klien seperti CLI (`mysql`) atau phpMyAdmin[cite: 29]. Penerapan prinsip *least privilege* sangat penting dalam keamanan basis data, yaitu membatasi hak akses akun pengguna agar hanya dapat mengelola basis data spesifik miliknya demi mencegah kerusakan data sistem maupun data pengguna lain[cite: 31]. Git digunakan sebagai kendali versi (*version control*) untuk mencatat setiap tahap perubahan skrip dan dokumen proyek secara bertahap dan teracak (*trackable*)[cite: 31].

## 3. Hasil Langkah Percobaan
### A. Menjalankan Layanan MariaDB
![Status XAMPP Control Panel](img/p01_xampp_control.png)
*Gambar 1: Layanan MySQL/MariaDB berhasil dijalankan pada port 3306 melalui XAMPP Control Panel.*[cite: 32]

### B. Mengakses MariaDB CLI dan Mengamankan Root
![Koneksi Root CLI](img/p01_cli_root.png)
*Gambar 2: Verifikasi koneksi awal akun root dan pengecekan versi server MariaDB.*[cite: 32, 33]

```sql
-- Mengamankan akun root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'PasswordRootAman123!';
FLUSH PRIVILEGES;
```[cite: 33]

### C. Pembuatan Basis Data dan Akun Kerja
![Pembuatan User dan DB](img/p01_create_user_db.png)
*Gambar 3: Eksekusi pembuatan basis data Modul_01 dan user kerja syifa_105.*[cite: 34]

```sql
-- Membuat basis data praktik
CREATE DATABASE Modul_01  
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Membuat user kerja dengan password 'syifacantik'
CREATE USER 'syifa_105'@'localhost' IDENTIFIED BY 'syifacantik';

-- Memberikan hak akses penuh hanya pada basis data Modul_01
GRANT ALL PRIVILEGES ON Modul_01.* TO 'syifa_105'@'localhost';
FLUSH PRIVILEGES;
```[cite: 34]

### D. Konfigurasi phpMyAdmin Mode Cookie
![Halaman Login phpMyAdmin](img/p01_phpmyadmin_cookie.png)
*Gambar 4: Halaman login phpMyAdmin dengan autentikasi mode cookie setelah konfigurasi config.inc.php diubah.*[cite: 35]

## 4. Jawaban Titik Analisis
* **Titik Analisis 1:** Meskipun tombol di XAMPP berlabel "MySQL", server yang sebenarnya berjalan adalah MariaDB 10.4[cite: 20]. Dokumentasi MySQL masih relevan untuk perintah SQL umum (seperti DDL, DML, JOIN), tetapi dokumentasi MariaDB wajib dirujuk saat menghadapi fitur khusus, mesin penyimpanan (*storage engine*), pengoperasian akun/plugin autentikasi, serta kode galat spesifik MariaDB[cite: 20, 29].
* **Titik Analisis 2:** Saat masuk dengan `mysql -u root` tanpa `-p`, muncul pesan `ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)`[cite: 38]. Frasa `(using password: NO)` menandakan bahwa klien mencoba masuk tanpa mengirimkan password sama sekali, padahal akun root sudah diberi password[cite: 38].
* **Titik Analisis 3:** `information_schema` tetap terlihat oleh user `syifa_105` karena merupakan basis data sistem read-only yang menyediakan metadata tentang struktur objek yang berhak diakses oleh user tersebut[cite: 33, 34]. Sebaliknya, akses ke basis data `mysql` ditolak dengan `ERROR 1044` karena user `syifa_105` tidak diberi hak akses (*grant*) ke basis data internal server tersebut[cite: 34]. Perbedaannya: `ERROR 1044` terjadi ketika koneksi berhasil tetapi akses ke basis data spesifik ditolak, sedangkan `ERROR 1045` terjadi pada tahap autentikasi login awal (username/password salah atau tidak sesuai)[cite: 34, 38].
* **Titik Analisis 4:** Mode `'cookie'` lebih aman daripada mode `'config'` karena meminta pengguna memasukkan nama pengguna dan password secara manual setiap kali membuka halaman web[cite: 35]. Mode `'config'` menyimpan password langsung secara teks polos (*plain text*) di dalam berkas `config.inc.php`, yang berisiko terbaca oleh pihak tak berwenang jika server terkena celah keamanan[cite: 31, 35].

## 5. Hasil Latihan dan Modifikasi
1. **Membuat Akun Tamu (Read-Only):**
```sql
CREATE USER 'tamu_105'@'localhost' IDENTIFIED BY 'tamu123';
GRANT SELECT ON Modul_01.* TO 'tamu_105'@'localhost';
FLUSH PRIVILEGES;
```[cite: 36]
Saat mencoba eksekusi `CREATE TABLE uji (id INT);` menggunakan akun `tamu_105`, muncul `ERROR 1142 (42000): CREATE command denied to user 'tamu_105'@'localhost' for table 'uji'`. Galat ini menunjukkan bahwa akun tersebut hanya memiliki izin `SELECT` (membaca) dan ditolak saat mencoba mengubah struktur/perintah DDL[cite: 34, 36].

2. **Skrip Idem-poten (Dapat Dijalankan Berulang Tanpa Galat):**
```sql
CREATE DATABASE IF NOT EXISTS Modul_01
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'syifa_105'@'localhost' IDENTIFIED BY 'syifacantik';
GRANT ALL PRIVILEGES ON Modul_01.* TO 'syifa_105'@'localhost';
FLUSH PRIVILEGES;
```[cite: 36]

## 6. Tugas Mandiri: Milestone Proyek 01
* Tema Proyek: Akademik (Kode Tema: `akad`) [berdasarkan NIM 05][cite: 18]
* Nama Organisasi Fiktif: SIAKAD Cendekia SA (Inisial: SA - Syifa A)[cite: 37]
* Basis Data Proyek: `akad_105`[cite: 36]
* Akun Developer: `dev_105`[cite: 36]

```sql
-- Pembuatan basis data dan user proyek
CREATE DATABASE IF NOT EXISTS akad_105
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dev_105'@'localhost' IDENTIFIED BY 'devpass105';
GRANT ALL PRIVILEGES ON akad_105.* TO 'dev_105'@'localhost';
FLUSH PRIVILEGES;
```[cite: 34, 36]

Berkas `.gitignore` telah ditambahkan ke repositori untuk mengabaikan berkas sensitif seperti `*.env` dan file kredensial[cite: 37].

## 7. Pembahasan dan Kendala
* **Kendala:** Saat pengubahan password `root`, phpMyAdmin mengalami masalah kuis/akses tertolak (`#1045 Access denied`)[cite: 34, 38].
* **Penyelesaian:** Kendala ini diatasi dengan mengubah opsi autentikasi `$cfg['Servers'][$i]['auth_type']` pada berkas `C:\xampp\phpMyAdmin\config.inc.php` dari `'config'` menjadi `'cookie'`, sehingga phpMyAdmin menampilkan formulir login interaktif[cite: 35, 38].

## 8. Kesimpulan
Melalui praktikum Pertemuan 1, lingkungan kerja MariaDB pada XAMPP telah berhasil dikonfigurasi secara aman[cite: 28]. Penerapan pengamanan akun `root` dan pembuatan user terbatas (`syifa_105` dan `dev_105`) berhasil mengisolasi hak akses sesuai prinsip *least privilege*[cite: 31, 34]. Selain itu, repositori Git telah berhasil terhubung dengan GitHub sebagai sarana pencatatan perubahan skrip SQL dan pengerjaan milestone proyek secara berkelanjutan[cite: 28, 31].

## 9. Pernyataan Penggunaan AI
Menggunakan asisten AI (Gemini) untuk membantu menyusun kerangka laporan praktikum, membantu formulasi perintah pengamanan user, serta memverifikasi arti dan perbedaan kode galat SQL[cite: 16].

## 10. Bukti Git
* **Tautan Repositori:** `https://github.com/syifa105/basisdata-2301010105`[cite: 36]
* **Hash Commit:** `3f9c2ab` (Pesan commit: `p01: inisialisasi repositori dan skrip lingkungan`)[cite: 36]

## Checklist
- [x] Identitas Laporan Lengkap (Nama, NIM, Kelas, Tanggal)[cite: 23]
- [x] Tujuan Praktikum ditulis ulang dengan bahasa sendiri[cite: 23]
- [x] Ringkasan Dasar Teori dibuat ringkas dan jelas[cite: 23]
- [x] Tangkapan layar hasil percobaan beserta keterangannya[cite: 23, 25]
- [x] Jawaban Titik Analisis 1-4 dijawab lengkap[cite: 25]
- [x] Hasil Latihan & Modifikasi beserta pembahasannya[cite: 23, 25]
- [x] Milestone Proyek 01 terlampir[cite: 24, 25]
- [x] Pembahasan, Kendala, dan Kesimpulan disertakan[cite: 24]
- [x] Pernyataan Penggunaan AI diisi[cite: 24]
- [x] Bukti Tautan Repositori dan Hash Commit terlampir[cite: 24, 25]