# Final Outpost

Proyek 2D Top-Down Wave-Based Zombie Survival Shooter yang dibangun dengan Godot Engine 4.x menggunakan GDScript, sebagai bagian dari portofolio untuk melamar magang di bidang game development.

---

## Tentang Proyek

Final Outpost dibuat sebagai portofolio untuk melamar posisi magang game developer. Melalui proyek ini, saya mengeksplorasi Godot Engine 4.x sebagai pilihan engine 2D. Godot terasa sangat ringan, responsif, dan simpel untuk digunakan dalam membangun gim 2D tanpa mengorbankan kualitas performa.

Programming sendiri merupakan salah satu passion saya sebagai mahasiswa, di mana membangun sesuatu yang interaktif dan dapat langsung dimainkan memberikan kepuasan teknis tersendiri. Proyek ini berfokus pada penerapan logika dasar pengembangan gim 2D, mulai dari pergerakan karakter, sistem tembak, hingga manajemen status global.

---

## 📸 Tangkapan Layar (Gameplay)

<p align="center">
  <img src="assets/Screenshoot/Screenshot 2026-07-29 031808.png" width="48%" alt="Final Outpost Gameplay 1" />
  <img src="assets/Screenshoot/Screenshot 2026-07-29 031854.png" width="48%" alt="Final Outpost Gameplay 2" />
</p>

---

## Kenapa Top-Down Zombie Survival Shooter?

Genre *Top-Down Survival Shooter* adalah salah satu genre yang sangat menarik karena menawarkan aksi yang cepat dan pengujian refleks pemain. Ada kepuasan tersendiri saat berhasil mengontrol area, menghindari kepungan musuh, dan bertahan hidup dari satu gelombang ke gelombang berikutnya.

Secara teknikal, genre ini sangat pas dieksplorasi untuk portofolio karena mencakup banyak logika inti rekayasa gim:
1. Kalkulasi pergerakan vektor 8-arah (*WASD movement*).
2. Mekanik pembidikan dinamis yang mengikuti kursor mouse (*mouse-aim shooting*).
3. Logika *spawner* musuh bertahap berbasis gelombang (*wave system*).
4. Pengelolaan status permainan (HP, Wave, Score) yang terisolasi.

---

## Fitur & Mekanik

- **Pergerakan & Kombatan**: Kontrol top-down 8-arah (WASD) yang halus, dilengkapi tombol lari cepat (`SHIFT`) dan sistem tembak peluru yang otomatis mengarah ke kursor mouse.
- **Dynamic Wave Spawner**: Zombie muncul secara bertahap dalam beberapa gelombang. Mengalahkan seluruh zombie pada wave aktif akan memicu transisi ke wave berikutnya hingga kondisi *Victory*.
- **Status Persisten (Autoload)**: Menggunakan `GameManager.gd` sebagai Singleton global untuk menyimpan skor, level wave, dan HP pemain agar tidak ter-reset secara tidak sengaja.
- **Event-Driven HUD**: Tampilan antarmuka (HP Bar, Score, Wave Count) yang diperbarui secara otomatis menggunakan sinyal (*signals*) bawaan Godot.
- **Latar Belakang Parallax**: Efek kedalaman visual 2D menggunakan node `ParallaxBackground` multi-layer.

---

## Cara Main

| Tombol | Aksi |
| :--- | :--- |
| **W, A, S, D** | Bergerak (Atas / Bawah / Kiri / Kanan) |
| **Shift (Tahan)** | Lari Cepat (*Sprint*) |
| **Kursor Mouse** | Mengarahkan Tembakan (*Aiming*) |
| **Klik Kiri** | Menembak Peluru (*Attack*) |

Jelajahi area, hindari kejaran zombie, dan gunakan mouse untuk membidik serta menembak mereka. Setiap zombie yang dikalahkan akan menambah skor permainan.

Bertahanlah dari setiap gelombang zombie yang datang. Jika seluruh gelombang (*waves*) berhasil diselesaikan, layar **Victory** akan muncul. Namun jika HP pemain habis, permainan akan berakhir (*Game Over*).

---

## Tantangan yang Dihadapi

Membangun proyek ini memberikan beberapa tantangan teknis menarik, antara lain:

1. **Restrukturisasi Aset & Peringatan Node Parallax**: File aset gambar sempat menumpuk di folder utama (*root*) dan node `ParallaxLayer` memunculkan peringatan konfigurasi karena diletakkan sejajar dengan `ParallaxBackground`.
2. **Penyimpanan Data Global**: Mencegah variabel penting seperti skor, wave, dan HP pemain ter-reset saat terjadi *restart* atau pergantian scene.
3. **Sinkronisasi Rotasi Tembakan**: Menyesuaikan arah munculnya proyektil peluru agar selalu presisi mengikuti posisi kursor mouse secara *real-time*.

---

## Cara Menyelesaikan Tantangan

Pendekatan yang dilakukan berfokus pada analisis logika dan penerapan *best practice* Godot:

- **Restrukturisasi Folder & Node**: Memindahkan seluruh file gambar ke folder `assets/background/` melalui editor Godot serta menjadikan `ParallaxLayer` sebagai *child* langsung di bawah `ParallaxBackground`.
- **Penerapan Autoload (Singleton)**: Memindahkan seluruh variabel status utama ke skrip `GameManager.gd` dan mendaftarkannya di *Project Settings Autoload*.
- **Pemanfaatan AI secara Spesifik**: AI dimanfaatkan sebagai mitra *code review* dan diskusi arsitektur—seperti memvalidasi struktur folder, mencari penyebab peringatan node, serta membantu merapikan dokumentasi agar standar industri.

---

## Hasil Akhir

Saat ini, gim sudah dapat dimainkan secara utuh (*playable prototype*): pemain bisa bergerak, berlari, membidik kursor, menembak zombie, melewati gelombang musuh (*wave*), memantau HUD secara *real-time*, hingga mencapai kondisi *Victory* atau *Game Over*.

---

## Rencana Pengembangan

Beberapa rencana fitur yang ingin ditambahkan ke depannya:
- Variasi tipe zombie baru (zombie cepat dan zombie bertubuh besar/tank).
- Variasi senjata tambahan (misalnya shotgun atau automatic rifle).
- Penambahan efek suara (SFX) tembakan/zombie dan musik latar (BGM) dinamis.

---

## Tech Stack

- **Engine**: Godot Engine 4.x
- **Bahasa**: GDScript
- **Arsitektur**: Scene-based (`main.tscn`, `player.tscn`, `zombie.tscn`, `hud.tscn`) dengan Autoload `GameManager.gd` untuk penyimpanan status global persisten.
