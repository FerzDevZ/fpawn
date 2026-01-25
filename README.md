# fpawn v12.0 - FerzDevZ Performance Suite

Versi ini didedikasikan untuk **KECEPATAN** dan **STABILITAS**. Kami membuang generator kode (karena Anda sudah jago coding) dan menggantinya dengan tool optimasi tingkat lanjut.

## Fitur Baru: Engineering Tools

### 1. Production Optimizer (`--optimize`)
Membuat file `.amx` sekecil dan secepat mungkin untuk rilis publik.
- **Strip Debug Info**: Menghapus simbol debug (-d0) untuk mengurangi ukuran file drastis.
- **Max Optimization**: Mengaktifkan flag `-O3` untuk performa eksekusi tertinggi.
- **Output**: Menghasilkan file yang bersih, cocok untuk upload ke hosting.

**Cara Pakai:**
```bash
fpawn --optimize gamemode.pwn
```

### 2. Server Benchmarking (`--benchmark`)
Stress-test server Anda sebelum pemain masuk.
- **Startup Test**: Mengukur seberapa cepat server booting dalam milidetik.
- **Tick Stability**: Menjalankan simulasi beban selama 10 detik.
- **Log Analysis**: Mencari error tersembunyi selama beban tinggi.

**Cara Pakai:**
```bash
fpawn --benchmark
```

## Tetap Powerfull (Fitur Sebelumnya)
Semua fitur manajemen server tetap ada:
- `fpawn --create-server`
- `fpawn --plugin`
- `fpawn --doctor`
- `fpawn --backup`

---
**Powered by FerzDevZ** (Engineering Excellence)
