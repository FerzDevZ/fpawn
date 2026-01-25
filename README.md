# fpawn v11.0 - FerzDevZ Cloud & AI Edition

Tidak hanya mengelola, `fpawn` sekarang bisa **Menulis Kode** dan **Menyimpan Data ke Cloud**.

## Fitur Baru: Logic Generator (AI Template)

Malas ngetik boilerplate command atau dialog? Biarkan `fpawn` yang menulisnya.

**Cara Pakai:**
```bash
fpawn --gen cmd:heal
```
*Output:*
```pawn
CMD:heal(playerid, params[]) {
    if (isnull(params)) return SendClientMessage(playerid, -1, "Usage: /heal [params]");
    // TODO: Add logic for heal
    return 1;
}
```

**Template Lainnya:**
- `fpawn --gen dialog:register` -> Membuat struktur Dialog & Response.
- `fpawn --gen mysql:loadplayer` -> Membuat callback loading data MySQL.

## Fitur Baru: Cloud Backup

Jangan pernah kehilangan data server lagi. Fitur ini akan otomatis mem-backup script dan config Anda ke GitHub (Private/Public Repo).

**Cara Pakai:**
```bash
fpawn --backup
```
`fpawn` akan melakukan `git add`, `commit` otomatis, dan `push` ke branch main Anda dalam satu detik.

## Master Dashboard v11
Semua fitur di atas bisa diakses lewat menu visual:
```bash
fpawn
```
Pilih **[5] Logic Generator** atau **[6] Cloud Backup**.

---
**Powered by FerzDevZ**
