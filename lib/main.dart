import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Film Indonesia'),
          backgroundColor: Colors.blueAccent,
        ),
        // Memanggil fungsi pembuat daftar film
        body: daftarFilmVertikal(),
      ),
    );
  }
}

// Fungsi untuk membuat list yang bisa di-scroll ke bawah
Widget daftarFilmVertikal() {
  // Daftar 10 film Indonesia beserta URL posternya (Menggunakan TMDB yang lebih stabil)
  final List<Map<String, String>> films = [
    {
      'judul': 'Pengabdi Setan',
      'url_foto': 'https://image.tmdb.org/t/p/w500/wtUaJFqFZMFjgN7KM0ikIFiemYB.jpg'
    },
    {
      'judul': 'Laskar Pelangi',
      'url_foto': 'https://image.tmdb.org/t/p/w500/qoiVrVK09K7GQfrTnRUcAclu3L.jpg'
    },
    {
      'judul': 'Gundala',
      'url_foto': 'https://image.tmdb.org/t/p/w500/wZCo5qUz3IdIhs6466B9PpFglXU.jpg'
    },
    {
      'judul': 'Warkop DKI Reborn',
      'url_foto': 'https://image.tmdb.org/t/p/w500/uSaaCp44SrcLIrpIhaWyRsYKtOm.jpg'
    },
    {
      'judul': 'Miracle in Cell No. 7',
      'url_foto': 'https://image.tmdb.org/t/p/w500/bOth4QmNyEkalwahfPCfiXjNh1r.jpg'
    },
    {
      'judul': 'KKN di Desa Penari',
      'url_foto': 'https://image.tmdb.org/t/p/w500/63InZxeGgfNQCoWkImR14fB99AY.jpg'
    },
    {
      'judul': 'Habibie & Ainun',
      'url_foto': 'https://image.tmdb.org/t/p/w500/eOdYhBFF7vE5v83KVVQfDEyLgEu.jpg'
    },
    {
      'judul': 'Cek Toko Sebelah',
      'url_foto': 'https://image.tmdb.org/t/p/w500/ygOPhiygrijDa0E7x2ETWWXE6HP.jpg'
    },
    {
      'judul': 'Mencuri Raden Saleh',
      'url_foto': 'https://image.tmdb.org/t/p/w500/66yOibmlqxASFoNyEZIORELJqBC.jpg'
    },
    {
      'judul': 'Ayat-Ayat Cinta',
      'url_foto': 'https://image.tmdb.org/t/p/w500/pWFTabzMwSbso1DsRwE8My4IL1h.jpg'
    }
  ];

  return ListView.builder(
    itemCount: films.length,
    itemBuilder: (context, index) {
      
      // Membuat kotak untuk setiap 1 baris film
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4) // Efek bayangan tipis
          ],
        ),
        
        // ROW = Menyusun elemen secara Horizontal (Kiri ke Kanan)
        child: Row(
          children: [
            // ==========================================
            // 1. BAGIAN KIRI: MENAMPILKAN FOTO FILM
            // ==========================================
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                films[index]['url_foto']!, // Mengambil URL foto dari data
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                // Menambahkan indikator loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 80,
                    height: 110,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                // Menangani error jika gambar gagal dimuat
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error memuat gambar: $error');
                  return Container(
                    width: 80,
                    height: 110,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            
            const SizedBox(width: 16), // Jarak kosong antara foto dan teks

            // ==========================================
            // 2. BAGIAN KANAN: JUDUL & RATING
            // ==========================================
            // Expanded digunakan agar teks mengisi sisa ruang di kanan dan tidak error
            Expanded(
              // COLUMN = Menyusun elemen secara Vertikal (Atas ke Bawah)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                children: [
                  
                  // Judul Film dari array
                  Text(
                    films[index]['judul']!,
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8), // Jarak antara judul dan rating
                  
                  // Rating (Bintang dan Angka disusun kiri-kanan pakai Row)
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 20), // Icon Bintang
                      SizedBox(width: 4),
                      Text(
                        '4.8', // Angka Rating
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}