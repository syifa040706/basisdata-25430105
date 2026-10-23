-- =============================================================================
-- PRAKTIKUM BASIS DATA - PERTEMUAN 05: DATA DEFINITION LANGUAGE (DDL)
-- =============================================================================
-- Nama       : Syifa
-- NIM        : 25430105
-- Proyek     : Toko Daring Cendekia SA (Sistem E-Commerce)
-- Parameter P: P = (05 MOD 9) + 1 = 6 -> Batas P+2 = 8 item
-- File       : modul5/p05_ddl_25430105.sql
-- Keterangan : Skrip DDL lengkap, idempoten (dapat dijalankan ulang dari kosong),
--              memenuhi kaidah penamaan:
--              - Kunci Primer : id_<nama_tabel>
--              - Kunci Tamu   : id_<nama_tabel_tujuan>
--              - Constraint terhubung langsung ke kode Aturan Bisnis (AB-xx)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. PEMBUATAN DAN INISIALISASI BASIS DATA
-- -----------------------------------------------------------------------------
DROP DATABASE IF EXISTS toko_daring_25430105;
CREATE DATABASE toko_daring_25430105
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE toko_daring_25430105;

-- Nonaktifkan pemeriksaan foreign key sementara untuk memastikan drop bersih jika tabel ada
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS admin;
DROP TABLE IF EXISTS pelanggan;
SET FOREIGN_KEY_CHECKS = 1;


-- -----------------------------------------------------------------------------
-- 2. TABEL: pelanggan (Master Data Pelanggan)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_pelanggan
-- Aturan Bisnis:
--   AB-02 : Menampung akun pelanggan terdaftar untuk transaksi pemesanan
--   AB-06 : email_pelanggan dan no_hp_pelanggan bersifat unik (identitas unik)
-- -----------------------------------------------------------------------------
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT,
    kode_pelanggan VARCHAR(20) NOT NULL,
    nama_pelanggan VARCHAR(100) NOT NULL,
    email_pelanggan VARCHAR(100) NOT NULL,
    no_hp_pelanggan VARCHAR(20) NOT NULL,
    alamat_pelanggan TEXT NOT NULL,
    tgl_daftar DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_pelanggan PRIMARY KEY (id_pelanggan),

    -- Aturan Bisnis AB-06: Kode pelanggan, email, dan no HP wajib unik
    CONSTRAINT uk_pelanggan_kode UNIQUE (kode_pelanggan),
    CONSTRAINT uk_pelanggan_email UNIQUE (email_pelanggan),     -- [AB-06]
    CONSTRAINT uk_pelanggan_no_hp UNIQUE (no_hp_pelanggan)      -- [AB-06]
) ENGINE = InnoDB;


-- -----------------------------------------------------------------------------
-- 3. TABEL: admin (Pengelola Katalog & Operasional Sistem)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_admin
-- -----------------------------------------------------------------------------
CREATE TABLE admin (
    id_admin INT AUTO_INCREMENT,
    kode_admin VARCHAR(20) NOT NULL,
    nama_admin VARCHAR(100) NOT NULL,
    peran_admin VARCHAR(50) NOT NULL DEFAULT 'Admin Produk',
    email_admin VARCHAR(100) NOT NULL,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_admin PRIMARY KEY (id_admin),

    CONSTRAINT uk_admin_kode UNIQUE (kode_admin),
    CONSTRAINT uk_admin_email UNIQUE (email_admin)
) ENGINE = InnoDB;


-- -----------------------------------------------------------------------------
-- 4. TABEL: kategori (Master Klasifikasi Produk)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_kategori
-- -----------------------------------------------------------------------------
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT,
    kode_kategori VARCHAR(20) NOT NULL,
    nama_kategori VARCHAR(100) NOT NULL,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_kategori PRIMARY KEY (id_kategori),

    CONSTRAINT uk_kategori_kode UNIQUE (kode_kategori)
) ENGINE = InnoDB;


-- -----------------------------------------------------------------------------
-- 5. TABEL: produk (Katalog Barang Dagangan)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_produk
-- Kunci Tamu   : id_kategori (merujuk ke tabel kategori)
--                id_admin    (merujuk ke tabel admin)
-- Aturan Bisnis:
--   AB-05 : Stok produk tidak boleh negatif (stok_produk >= 0)
-- -----------------------------------------------------------------------------
CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT,
    kode_produk VARCHAR(20) NOT NULL,
    nama_produk VARCHAR(150) NOT NULL,
    harga_produk DECIMAL(12, 2) NOT NULL,
    stok_produk INT NOT NULL DEFAULT 0,
    id_kategori INT NOT NULL,
    id_admin INT NOT NULL,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_produk PRIMARY KEY (id_produk),

    -- Kunci Tamu (Format: id_<nama_tabel_tujuan>)
    CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori)
        REFERENCES kategori (id_kategori)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_produk_admin FOREIGN KEY (id_admin)
        REFERENCES admin (id_admin)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Constraint Keunikan Kode Produk
    CONSTRAINT uk_produk_kode UNIQUE (kode_produk),

    -- Aturan Bisnis AB-05: Stok barang tidak boleh bernilai negatif
    CONSTRAINT chk_produk_stok CHECK (stok_produk >= 0),         -- [AB-05]

    -- Validasi Harga Katalog Positif
    CONSTRAINT chk_produk_harga CHECK (harga_produk >= 0)
) ENGINE = InnoDB;


-- -----------------------------------------------------------------------------
-- 6. TABEL: pesanan (Header Transaksi Penjualan)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_pesanan
-- Kunci Tamu   : id_pelanggan (merujuk ke tabel pelanggan)
-- Aturan Bisnis:
--   AB-01 : Setiap pesanan memiliki nomor invoice unik
--   AB-02 : Pembelian hanya dapat dilakukan oleh pelanggan terdaftar
--   AB-07 : Alamat pengiriman dan ongkos kirim dicatat per transaksi pesanan
--   AB-08 : Status pesanan terkontrol melalui ENUM
-- -----------------------------------------------------------------------------
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT,
    no_invoice VARCHAR(30) NOT NULL,
    tgl_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    alamat_kirim TEXT NOT NULL,
    ongkir DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_bayar DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    status_pesanan ENUM('Pending', 'Lunas', 'Dikirim', 'Selesai', 'Batal') NOT NULL DEFAULT 'Pending',
    id_pelanggan INT NOT NULL,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_pesanan PRIMARY KEY (id_pesanan),

    -- Kunci Tamu (Format: id_<nama_tabel_tujuan>) - [AB-02]
    CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan)
        REFERENCES pelanggan (id_pelanggan)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Aturan Bisnis AB-01: Nomor invoice unik per transaksi
    CONSTRAINT uk_pesanan_invoice UNIQUE (no_invoice),           -- [AB-01]

    -- Aturan Bisnis AB-07: Ongkos kirim tidak boleh bernilai negatif
    CONSTRAINT chk_pesanan_ongkir CHECK (ongkir >= 0),          -- [AB-07]

    -- Validasi Total Bayar tidak bernilai negatif
    CONSTRAINT chk_pesanan_total CHECK (total_bayar >= 0)
) ENGINE = InnoDB;


-- -----------------------------------------------------------------------------
-- 7. TABEL: detail_pesanan (Rincian Item Transaksi Penjualan)
-- -----------------------------------------------------------------------------
-- Kunci Primer : id_detail_pesanan
-- Kunci Tamu   : id_pesanan (merujuk ke tabel pesanan)
--                id_produk  (merujuk ke tabel produk)
-- Aturan Bisnis:
--   AB-01 : Minimal memuat 1 item (Secara relasional memerlukan transaksi, ditandai Modul 14)
--   AB-03 : Batas maksimal pembelian produk per item dalam transaksi adalah P+2 = 8 item (NIM 05 -> P=6)
--   AB-04 : Harga produk disimpan per item detail pesanan (historis)
-- -----------------------------------------------------------------------------
CREATE TABLE detail_pesanan (
    id_detail_pesanan INT AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    qty_detail INT NOT NULL,
    harga_satuan_detail DECIMAL(12, 2) NOT NULL,

    -- Kunci Primer (Format: id_<nama_tabel>)
    CONSTRAINT pk_detail_pesanan PRIMARY KEY (id_detail_pesanan),

    -- Kunci Tamu (Format: id_<nama_tabel_tujuan>)
    CONSTRAINT fk_detail_pesanan_pesanan FOREIGN KEY (id_pesanan)
        REFERENCES pesanan (id_pesanan)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk)
        REFERENCES produk (id_produk)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    -- Mencegah duplikasi produk yang sama dalam satu transaksi pesanan
    CONSTRAINT uk_detail_pesanan_item UNIQUE (id_pesanan, id_produk),

    -- -------------------------------------------------------------------------
    -- ANALISIS ATURAN BATAS P+2 (Modul 2): P = (05 MOD 9) + 1 = 6 -> P+2 = 8
    -- 1. Tingkat Satu Baris (Single-Row Scope):
    --    Kuantitas pembelian per baris item dibatasi minimal 1 dan maksimal 8 item.
    --    Dapat diwujudkan secara mandiri menggunakan CONSTRAINT CHECK.
    -- -------------------------------------------------------------------------
    CONSTRAINT chk_detail_qty CHECK (qty_detail >= 1 AND qty_detail <= 8), -- [AB-03]

    -- -------------------------------------------------------------------------
    -- 2. Tingkat Banyak Baris / Agregasi Multi-Baris (Multi-Row Scope):
    --    CATATAN INTEGRITAS: Aturan bahwa total akumulasi seluruh baris item
    --    dalam satu transaksi tidak boleh melebihi 8 item, serta aturan AB-01
    --    bahwa satu pesanan wajib memiliki minimal 1 rincian item,
    --    TIDAK DAPAT DIJAGA OLEH CONSTRAINT CHECK DDL!
    --    Alasan Teknis: Constraint CHECK pada MariaDB/MySQL hanya mengevaluasi
    --    kondisi nilai kolom dalam satu baris individual saat INSERT/UPDATE,
    --    dan tidak mengizinkan kueri agregasi tabel silang baris (seperti SUM()
    --    atau COUNT()).
    --    STATUS: Ditandai untuk diselesaikan secara komprehensif pada Modul 14
    --            melalui mekanisme Transaksi ACID (START TRANSACTION ... COMMIT)
    --            dan Database Trigger / Stored Procedure.
    -- -------------------------------------------------------------------------

    -- Aturan Bisnis AB-04: Harga jual disimpan per rincian pesanan dan tidak boleh negatif
    CONSTRAINT chk_detail_harga CHECK (harga_satuan_detail >= 0) -- [AB-04]
) ENGINE = InnoDB;


-- =============================================================================
-- DATA SAMPEL PENGUJIAN (SEED DATA DML UNTUK VERIFIKASI STRUKTUR)
-- =============================================================================

-- Master Pelanggan
INSERT INTO pelanggan (kode_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan)
VALUES
('PLG-0105', 'Syifa', 'syifa@cendekia.ac.id', '08123456789', 'Jl. Metro No. 105, Lampung'),
('PLG-0106', 'Ahmad Pratama', 'ahmad@example.com', '08129876543', 'Jl. Raden Intan No. 12, Bandar Lampung'),
('PLG-0107', 'Nadia Putri', 'nadia@example.com', '08571234987', 'Jl. Zainal Abidin Pagar Alam No. 45, Rajabasa');

-- Master Admin
INSERT INTO admin (kode_admin, nama_admin, peran_admin, email_admin)
VALUES
('ADM-01', 'Syifaul Maula', 'Super Admin', 'admin@cendekia.ac.id'),
('ADM-02', 'Budi Santoso', 'Admin Produk & Inventori', 'budi.admin@cendekia.ac.id');

-- Master Kategori
INSERT INTO kategori (kode_kategori, nama_kategori)
VALUES
('KAT-01', 'Pakaian Pria'),
('KAT-02', 'Pakaian Wanita'),
('KAT-03', 'Sepatu & Aksesoris'),
('KAT-04', 'Elektronik & Gadget');

-- Master Produk
INSERT INTO produk (kode_produk, nama_produk, harga_produk, stok_produk, id_kategori, id_admin)
VALUES
('PRD-001', 'Kemeja Casual Size M', 150000.00, 50, 1, 1),
('PRD-002', 'Celana Chino Slim Fit 32', 175000.00, 35, 1, 1),
('PRD-003', 'Blouse Wanita Floral L', 135000.00, 40, 2, 2),
('PRD-004', 'Sepatu Sneaker 42', 250000.00, 20, 3, 2),
('PRD-005', 'Tas Ransel Laptop 15 Inch', 220000.00, 25, 3, 2);

-- Transaksi Pesanan (Sesuai Invoice Dokumen Sumber Modul 2 & 4)
INSERT INTO pesanan (no_invoice, tgl_pesanan, alamat_kirim, ongkir, total_bayar, status_pesanan, id_pelanggan)
VALUES
('INV-202610-0012', '2026-10-06 14:00:00', 'Jl. Metro No. 105, Lampung', 20000.00, 570000.00, 'Dikirim', 1),
('INV-202610-0013', '2026-10-07 09:30:00', 'Jl. Raden Intan No. 12, Bandar Lampung', 15000.00, 325000.00, 'Lunas', 2);

-- Transaksi Detail Pesanan (Memenuhi Constraint AB-03 batas qty 1..8)
INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail, harga_satuan_detail)
VALUES
(1, 1, 2, 150000.00), -- Pesanan 1: Kemeja Casual (2 pcs x Rp150.000 = Rp300.000)
(1, 4, 1, 250000.00), -- Pesanan 1: Sepatu Sneaker (1 pcs x Rp250.000 = Rp250.000)
(2, 2, 1, 175000.00), -- Pesanan 2: Celana Chino (1 pcs x Rp175.000 = Rp175.000)
(2, 3, 1, 135000.00); -- Pesanan 2: Blouse Wanita (1 pcs x Rp135.000 = Rp135.000)

-- =============================================================================
-- AKHIR DARI SKRIP DDL modul5/p05_ddl_25430105.sql
-- =============================================================================
