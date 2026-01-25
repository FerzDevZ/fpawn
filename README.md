# fpawn v8.0 - FerzDevZ Workspace Edition

Versi **Workspace Edition** membawa `fpawn` ke level profesional yang lebih tinggi. Sekarang, `fpawn` mengerti perbedaan struktur folder antara project **SAMP Legacy** dan **open.mp**.

## Fitur Unggulan: Project Profiles

`fpawn` secara otomatis mengenali "Jenis Workspace" Anda tanpa perlu dikasih tahu:

### 1. Legacy Profile (Classic)
- **Terdeteksi Jika**: Ada folder `pawno/` atau file `server.cfg`.
- **Perilaku**: Otomatis memprioritaskan Engine **PAWNO** (Wine) dan mencari include di `./pawno/include`.

### 2. OMP Profile (Modern)
- **Terdeteksi Jika**: Ada folder `dependencies/` atau file `pawn.json`.
- **Perilaku**: Otomatis memprioritaskan Engine **QAWNO** (Native Linux) dan mencari include di `./include` & `./dependencies`.

## Cara Membuat Project Baru (Auto-Scaffold)

Sekarang Anda bisa membangun pondasi server dalam sekejap:

**Untuk SAMP Legacy (Gaya Lama):**
```bash
fpawn --init legacy
```

**Untuk open.mp (Gaya Modern):**
```bash
fpawn --init omp
```

## Keunggulan v8.0:
- **Tersolir**: Library open.mp tidak akan tercampur dengan library legacy.
- **Smart Priority**: Jika Anda menaruh `#include <a_samp>` di project OMP, `fpawn` cukup cerdas untuk tetap menggunakan engine modern namun mencari library yang kompatibel.
- **Zero Config**: Pindah antar folder project yang beda versi? `fpawn` langsung beradaptasi secara instan.

---
**Powered by FerzDevZ**
