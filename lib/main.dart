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
  // Daftar nama film
  final List<String> filmNames = [
    'Menangkan Hatiku',
    'Preman Pensiun',
    'Prestasi Terbaik',
    'Semangat Juang',
    'Pemberontakan',
    'Bataks',
    'Agama dan Cinta',
    'Menantang Takdir',
    'Pengantin Baru',
  ];

  return ListView.builder(
    itemCount: filmNames.length,
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
            // 1. BAGIAN KIRI: KOTAK PENGGANTI FOTO FILM
            // ==========================================
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.blueGrey, // Warna kotak foto
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.movie, color: Colors.white, size: 40),
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
                    filmNames[index],
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8), // Jarak antara judul dan rating
                  
                  // Rating (Bintang dan Angka disusun kiri-kanan pakai Row)
                  Row(
                    children: const [
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