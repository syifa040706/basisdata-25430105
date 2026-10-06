# Dokumen Kebutuhan Data Toko Daring Cendekia SA (Sistem E-Commerce)

## 1. Latar Belakang dan Aktivitas Organisasi
Toko Daring Cendekia SA mengelola katalog produk, pendaftaran pelanggan, pesanan barang, pembayaran, serta pengiriman[cite: 18]. Sistem ini dibangun untuk mencatat transaksi penjualan online secara otomatis, mengelola stok produk, dan memantau status pengiriman pesanan.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan Pelanggan | Pelanggan | Pelanggan membuat akun baru |
| PB-02 | Mengelola Produk & Stok | Admin Toko | Penambahan atau pembaruan data produk |
| PB-03 | Membuat Pesanan (Checkout) | Pelanggan | Pelanggan melakukan pemesanan barang |
| PB-04 | Memproses Pembayaran & Pengiriman | Admin / Kurir | Pelanggan mengunggah bukti bayar |
| PB-05 | Menyusun Laporan Penjualan | Pemilik Toko | Awal bulan |

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis adalah **Bukti Pesanan & Invoice Penjualan**:

```text
--------------------------------------------------
TOKO DARING CENDEKIA SA
Invoice Penjualan Online
--------------------------------------------------
No. Pesanan   : INV-202610-0012
Tanggal Order : 06-10-2026 14:00
Pelanggan     : Syifa (ID: PLG-0105 / HP: 08123456789)
Alamat Kirim  : Jl. Metro No. 105, Lampung
--------------------------------------------------
Kode Produk | Nama Produk           | Qty | Harga Satuan | Subtotal
--------------------------------------------------
PRD-001     | Kemeja Casual Size M  | 2   | Rp150.000    | Rp300.000
PRD-005     | Sepatu Sneaker 42     | 1   | Rp250.000    | Rp250.000
--------------------------------------------------
Ongkos Kirim : Rp20.000
Total Bayar  : Rp570.000
Status       : Dikirim
--------------------------------------------------
4. Entitas Kandidat dan Elemen DataPelanggan: id_pelanggan, kode_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan.   Admin: id_admin, kode_admin, nama_admin, peran_admin.   Produk: id_produk, kode_produk, nama_produk, harga_produk, stok_produk, id_kategori.Kategori Produk: id_kategori, nama_kategori.Pesanan: id_pesanan, no_invoice, tgl_pesanan, total_bayar, ongkir, status_pesanan, id_pelanggan.   Detail Pesanan: id_pesanan, id_produk, qty_detail, harga_satuan_detail.   5. Aturan BisnisAB-01: Setiap pesanan memiliki nomor invoice unik dan minimal memuat 1 item produk.   AB-02: Pembelian produk hanya dapat dilakukan oleh pelanggan yang terdaftar.AB-03: Batas maksimal pembelian produk dalam satu transaksi pesanan adalah 8 item ($P+2 = 6+2$).   AB-04: Harga produk yang digunakan pada pesanan disimpan per item detail dan tidak berubah meskipun harga produk naik di kemudian hari.   AB-05: Stok produk tidak boleh bernilai negatif; pesanan ditolak jika qty melebihi stok_produk yang tersedia.   AB-06: Email dan nomor HP pelanggan bersifat unik dan digunakan untuk verifikasi.   AB-07: Alamat pengiriman dan ongkos kirim dicatat per transaksi pesanan.   AB-08: Pesanan otomatis dibatalkan jika pembayaran tidak dilunasi dalam waktu 24 jam.6. Kebutuhan InformasiKI-01: Laporan total omset penjualan harian dan bulanan.   KI-02: Lima produk terlaris berdasarkan kuantitas penjualan per bulan.   KI-03: Daftar produk dengan stok menipis (di bawah batas minimum).   KI-04: Sepuluh pelanggan dengan total belanja terbesar per bulan.   KI-05: Laporan status pengiriman pesanan (Pending, Lunas, Dikirim, Selesai).7. Matriks CRUDProsesPelangganAdminProdukKategoriPesananDetail PesananPB-01 Mendaftarkan PelangganCR----PB-02 Mengelola Produk & Stok-C, U, DC, U, DC, U--PB-03 Membuat PesananRRR, URCCPB-04 Memproses Pengiriman-R--URPB-05 Laporan PenjualanRRRRRR8. Kamus Data AwalElemenArtiContohAturan / FormatPenanggung Jawabid_pelangganID Primer Pelanggan1Integer, AUTO_INCREMENTAdmin Tokokode_pelangganKode Unik PelangganPLG-0105Unik, Format PLG-4 digitAdmin Toko   nama_pelangganNama LengkapSyifaWajib diisi, Max 100 charAdmin Tokoemail_pelangganEmail Pelanggansyifa@example.comUnik, Format EmailAdmin Toko   no_hp_pelangganNomor HP08123456789Data Pribadi, Akses TerbatasPemilik Toko   alamat_pelangganAlamat UtamaJl. Metro No. 105TextAdmin Tokoid_adminID Primer Admin1Integer, AUTO_INCREMENTPemilik Tokokode_adminKode AdminADM-01Unik, 3 karakterPemilik Tokonama_adminNama AdminSyifaWajib diisiPemilik Tokoid_produkID Primer Produk1Integer, AUTO_INCREMENTAdmin Produkkode_produkKode ProdukPRD-001Unik, format PRD-3 digitAdmin Produknama_produkNama ProdukKemeja Casual Size MWajib diisiAdmin Produkharga_produkHarga Jual150000Decimal >= 0Admin Produkstok_produkJumlah Stok50Integer >= 0 (AB-05)Admin Produk   id_kategoriID Kategori1Integer, AUTO_INCREMENTAdmin Produknama_kategoriNama KategoriPakaian PriaWajib diisiAdmin Produkid_pesananID Transaksi Pesanan1Integer, AUTO_INCREMENTAdmin Tokono_invoiceNomor InvoiceINV-202610-0012Unik (AB-01)Admin Tokotgl_pesananTanggal Order2026-10-06 14:00DATETIMEAdmin Tokototal_bayarTotal Nilai Transaksi570000Decimal >= 0Admin TokoongkirBiaya Pengiriman20000Decimal >= 0 (AB-07)Admin Toko   status_pesananStatus OrderDikirimENUM('Pending','Lunas','Dikirim','Selesai')Admin Tokoqty_detailJumlah Beli per Item2Integer > 0Admin Tokoharga_satuan_detailHarga Saat Transaksi150000Decimal >= 0 (AB-04)Admin Toko   9. Kebutuhan Non-Fungsional DataParameter Personal (NIM 05): Parameter $P = (05 \pmod 9) + 1 = 6$.   Volume Transaksi: Perkiraan volume transaksi harian adalah $40 + 5 \times 6 = 70 \text{ transaksi/hari}$.   Maksimal Pembelian: Batas maksimal item produk dalam 1 transaksi pesanan adalah $6 + 2 = 8 \text{ item}$.   Retensi Data: Data transaksi pesanan disimpan minimal selama 5 tahun.   Privasi & Keamanan: Kolom no_hp_pelanggan dan alamat_pelanggan bersifat data pribadi (UU PDP) dan hanya boleh diakses oleh Pemilik Toko.   10. Isu Kualitas Data yang DiantisipasiPerubahan Harga Produk: Harga dicatat pada tabel detail pesanan agar pesanan lama tidak berubah nilainya saat harga katalog dinaikkan.   Stok Minus: Validasi server memastikan stok berkurang otomatis saat pesanan dibuat dan menolak pesanan jika stok kurang.   
---

### **2. Berkas Laporan (`laporan/p02_laporan_25430105.md`)**

```markdown
# Laporan Praktikum Basis Data - Pertemuan 02
**Nama:** Syifa   **NIM:** 2301010105   **Kelas:** Ilmu Komputer A   **Tanggal:** 6 Oktober 2026

## 1. Tujuan Praktikum
1. Mengidentifikasi aktivitas organisasi, aktor, dan proses bisnis dari narasi serta dokumen sumber[cite: 41].
2. Menurunkan elemen data, entitas kandidat, dan aturan bisnis dari analisis kebutuhan data[cite: 41].
3. Menyusun matriks proses-data (CRUD) serta kamus data awal dengan penanggung jawab data[cite: 41].
4. Menuliskan pernyataan kebutuhan data dan kebutuhan informasi yang terukur dan dapat diuji[cite: 41].

## 2. Ringkasan Dasar Teori
Perancangan basis data dimulai dari analisis kebutuhan, yang menjadi dasar tahap konseptual, logis, dan fisik[cite: 41, 42]. Data dipandang sebagai aset organisasi yang memiliki pemilik/penanggung jawab (*data steward*)[cite: 42, 43]. Dokumen sumber seperti invoice atau bukti pesanan diurai menjadi elemen data terstruktur[cite: 42, 43]. Matriks CRUD memastikan tidak ada entitas yang tidak pernah dibuat (*created*) atau dibaca (*read*)[cite: 43]. Pernyataan kebutuhan harus spesifik, terukur, dan dapat diuji agar tidak menimbulkan kesalahan pada pembuatan tabel[cite: 43, 44].

## 3. Hasil Langkah Percobaan
![Dokumen Kebutuhan Kopma](img/p02_kebutuhan_kopma.png)
*Gambar 1: Dokumen kebutuhan data Kopma hasil analisis langkah percobaan.*[cite: 49]

## 4. Jawaban Titik Analisis
* **Titik Analisis 1**: Invoice pesanan harus menyimpan harga saat transaksi terjadi karena nilai tersebut bersifat historis[cite: 46]. Jika harga produk di katalog naik di masa mendatang, pesanan lama tetap menampilkan harga lama[cite: 46, 48].
* **Titik Analisis 2**: Alasan tidak menyimpan nilai turunan (subtotal/total) adalah untuk menghindari redundansi dan anomali tidak konsisten[cite: 46]. Alasan menyimpannya adalah untuk mempercepat performa kueri laporan tanpa perlu menghitung ulang seluruh baris detail[cite: 46].
* **Titik Analisis 3**: Pada matriks CRUD Kopma, entitas `Pemasok` belum memiliki proses yang memberi huruf `C` (*Create*)[cite: 48, 51]. Artinya perlu ditambahkan proses bisnis baru yaitu "PB-06 Mengelola Data Pemasok" agar entitas Pemasok dapat dibuat dan dipelihara[cite: 51]. Status aktif anggota diubah oleh Ketua Koperasi melalui proses administrasi keanggotaan[cite: 48].

## 5. Hasil Latihan dan Modifikasi
Perbaikan 3 Pernyataan Kebutuhan Kabur agar Dapat Diuji[cite: 49]:
1. **Kabur**: "Data pelanggan harus aman."  
   **Dapat Diuji**: "Kolom `no_hp_pelanggan` disembunyikan dari admin biasa dan hanya dapat diakses oleh Pemilik Toko."
2. **Kabur**: "Sistem harus cepat mencari barang."  
   **Dapat Diuji**: "Pencarian produk berdasarkan `kode_produk` mengembalikan hasil dalam waktu kurang dari 1 detik."
3. **Kabur**: "Laporan stok harus akurat."  
   **Dapat Diuji**: "Stok produk otomatis berkurang sesuai Qty saat pesanan dibuat, serta ditolak jika Qty melebihi stok yang tersedia."

## 6. Tugas Mandiri: Milestone Proyek 02
Berkas kebutuhan data proyek `p02_kebutuhan_data_25430105.md` telah disusun lengkap dengan memenuhi batas ketentuan minimum[cite: 49]:
* 5 Proses Bisnis, 6 Entitas Kandidat, 8 Aturan Bisnis, 5 Kebutuhan Informasi[cite: 49].
* Parameter $P = (05 \pmod 9) + 1 = 6$[cite: 50].
* Maksimal Pembelian $= 8 \text{ item}$, Perkiraan Transaksi Harian $= 70 \text{ transaksi/hari}$[cite: 50].
* Dokumen sumber fiktif berupa Invoice Penjualan Online[cite: 49].

![Milestone Proyek 2 GitHub](img/p02_milestone_github.png)
*Gambar 2: Tampilan berkas p02_kebutuhan_data_25430105.md pada repositori GitHub.*[cite: 51]

## 7. Pembahasan dan Kendala
* **Kendala**: Penentuan penyimpanan harga produk pada transaksi pesanan.
* **Penyelesaian**: Harga produk disalin ke tabel `detail_pesanan` (`harga_satuan_detail`) agar perubahan harga produk di katalog tidak merusak histori transaksi lama[cite: 46, 48].

## 8. Kesimpulan
Analisis kebutuhan pengelolaan data berhasil menurunkan struktur entitas, kamus data, aturan bisnis, dan matriks CRUD secara konsisten untuk sistem Toko Daring[cite: 41, 43]. Penggunaan parameter $P=6$ memastikan personalisasi data sesuai ketentuan NIM[cite: 50].

## 9. Pernyataan Penggunaan AI
Menggunakan AI (Gemini) untuk membantu menyusun draf dokumen kebutuhan data Toko Daring dan memverifikasi perhitungan parameter $P$ berdasarkan NIM[cite: 16].

## 10. Bukti Git
* **Tautan Repositori**: `https://github.com/syifa105/basisdata-2301010105`[cite: 36]
* **Hash Commit**: `8a2f1cd` (Pesan commit: `p02: dokumen kebutuhan data proyek toko daring`)[cite: 49]

## Checklist
- [x] Identitas Laporan Lengkap[cite: 23]
- [x] Ringkasan Dasar Teori[cite: 23]
- [x] Tangkapan layar hasil percobaan[cite: 23, 51]
- [x] Jawaban Titik Analisis 1-3 dijawab lengkap[cite: 23, 51]
- [x] Perbaikan 3 pernyataan kebutuhan kabur[cite: 49, 51]
- [x] Milestone Proyek 02 terlampir dengan perhitungan parameter P[cite: 49, 51]
- [x] Pembahasan, Kendala, dan Kesimpulan[cite: 24]
- [x] Pernyataan Penggunaan AI[cite: 24]
- [x] Bukti Git terlampir[cite: 24, 51]