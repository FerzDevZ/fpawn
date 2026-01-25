# fpawn v10.0 - FerzDevZ Master Suite (The Final Upgrade)

Ini adalah puncak evolusi. `fpawn` kini bukan lagi sekadar tool CLI, melainkan sebuah **Aplikasi Terminal (TUI)** lengkap untuk mengelola seluruh aspek server SA-MP dan open.mp.

## Fitur Utama v10.0

### 1. Interactive Dashboard (TUI)
Lupa perintah? Cukup ketik `fpawn` (tanpa argumen) dan masuk ke dalam **Menu Visual**.
- Pilih menu dengan angka [1-7].
- Tidak perlu hafal flag panjang.
- `fpawn` akan menuntun Anda langkah demi langkah.

### 2. Production Build System (`--build`)
Siap rilis server? Fitur ini akan membuat paket `.zip` yang bersih dan aman.
- **Optimized Compile**: Mengkompilasi script dengan `-O2`.
- **Source Protection**: Otomatis menghapus file `.pwn` dari paket rilis agar kode Anda tidak dicuri.
- **Zip Packaging**: Menghasilkan `release.zip` siap upload ke VPS/Hosting.

### 3. The Doctor (`--doctor`)
Sebelum menyalakan server, periksa kesehatannya dulu.
- **Security Check**: Mendeteksi jika Anda menggunakan password default yang berbahaya.
- **Integrity Check**: Memastikan binary server dan folder penting tersedia.

## Cara Menggunakan Master Suite

**Masuk ke Dashboard:**
```bash
fpawn
```

**Membuat Versi Rilis (Production):**
```bash
fpawn --build
```

**Diagnosa Server:**
```bash
fpawn --doctor
```

## Tetap Kompatibel (Legacy Commands)
Semua perintah lama tetap berfungsi normal bagi Anda yang suka kecepatan CLI:
- `fpawn --create-server legacy`
- `fpawn --plugin streamer`
- `fpawn gamemode.pwn --watch`

---
**Powered by FerzDevZ** (The Legend)
