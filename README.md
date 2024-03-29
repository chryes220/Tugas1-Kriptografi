# Tugas1-Kriptografi
Sebuah website yang memungkinkan melakukan enkripsi/dekripsi _file_ dan teks dengan berbagai jenis _cipher_.

# Identitas Author
Dibuat oleh: 
1. Christine Hutabarat (13520005)
2. Fawwaz Anugrah Wiradhika Dharmasatya (13520086)

# Daftar Isi
1. [Deskripsi Singkat](#deskripsi-singkat)
2. [Requirement dan Instalasi](#requirement-dan-instalasi)
3. [Cara Penggunaan](#cara-penggunaan)

# Deskripsi Singkat
Website ini dikembangkan menggunakan bahasa `Ruby` dengan _framework_ `Ruby on Rails`. Pada website ini, pengguna bisa melakukan enkripsi maupun dekripsi pesan. Pesan dapat berupa masukan teks yang diketik pengguna maupun _file_. Berikut adalah _cipher_ yang didukung website ini:
1. Vigenere Cipher standard (26 huruf alfabet)
2. Varian Vigenere Cipher standard (26 huruf alfabet): Auto-Key Vigenere Cipher
3. Extended Vigenere Cipher (256 karakter ASCII)
4. Playfair Cipher (26 huruf alfabet)
5. Affine Cipher (26 huruf alfabet)
6. Hill Cipher (26 huruf alfabet)
7. Super enkripsi: gabungan Extended Vigenere Cipher dan cipher transposisi (metode
kolom)
8. Enigma cipher

# Requirement dan Instalasi
- Website ini ditulis dalam bahasa `Ruby` yang bisa diunduh pada tautan [berikut](https://www.ruby-lang.org/en/downloads/). Pada saat proses pengembangan digunakan `Ruby` versi **3.2.3**. 
- Untuk mempermudah pengembangan, digunakan _framework_ berupa `Ruby on Rails` yang dapat diunduh dengan perintah berikut:
```sh
gem install rails
```
Pada proses pengembangan aplikasi ini, digunakan versi terbaru `Ruby on Rails` yakni **7.1.3**. 

# Cara Penggunaan
**DISCLAIMER**: Program Ini hanya bisa dijalankan pada sistem operasi **Windows** berdasarkan pengujian yang kami lakukan.

Khusus untuk sistem operasi `Windows`, perlu untuk memanggil program `ruby` sebelum menjalankan _script_ seperti berikut:
```sh
ruby bin\rails server
```