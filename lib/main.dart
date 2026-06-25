// main.dart
import 'package:flutter/material.dart';
import 'favorite_button.dart'; 
import 'favorites_page.dart'; // ---> IMPORT HALAMAN BARU

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

// Kita buat widget pembungkus utama agar Scaffold memegang logika navigasi AppBar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Film Indonesia'),
        backgroundColor: Colors.blueAccent,
        actions: [
          // ---> TOMBOL DI NAVBAR UNTUK PINDAH HALAMAN
          IconButton(
            icon: const Icon(Icons.bookmark_sharp, size: 28),
            onPressed: () {
              // Logika Navigasi Flutter untuk membuka halaman baru (ditumpuk di atasnya)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              ).then((_) {
                // Saat pengguna kembali dari halaman favorit, segarkan halaman utama
                setState(() {});
              });
            },
          )
        ],
      ),
      body: const DaftarFilmVertikal(),
    );
  }
}

// Diubah menjadi StatefulWidget agar UI utama bisa merespon perubahan status favorit
class DaftarFilmVertikal extends StatefulWidget {
  const DaftarFilmVertikal({super.key});

  @override
  State<DaftarFilmVertikal> createState() => _DaftarFilmVertikalState();
}

class _DaftarFilmVertikalState extends State<DaftarFilmVertikal> {
  Future<List<Map<String, String>>> fetchFilms() async {
    await Future.delayed(const Duration(seconds: 5));
    return [
      {'judul': 'Pengabdi Setan', 'url_foto': 'https://image.tmdb.org/t/p/w500/wtUaJFqFZMFjgN7KM0ikIFiemYB.jpg'},
      {'judul': 'Laskar Pelangi', 'url_foto': 'https://image.tmdb.org/t/p/w500/qoiVrVK09K7GQfrTnRUcAclu3L.jpg'},
      {'judul': 'Gundala', 'url_foto': 'https://image.tmdb.org/t/p/w500/wZCo5qUz3IdIhs6466B9PpFglXU.jpg'},
      {'judul': 'Warkop DKI Reborn', 'url_foto': 'https://image.tmdb.org/t/p/w500/uSaaCp44SrcLIrpIhaWyRsYKtOm.jpg'},
      {'judul': 'Miracle in Cell No. 7', 'url_foto': 'https://image.tmdb.org/t/p/w500/bOth4QmNyEkalwahfPCfiXjNh1r.jpg'},
      {'film': 'KKN di Desa Penari', 'judul': 'KKN di Desa Penari', 'url_foto': 'https://image.tmdb.org/t/p/w500/63InZxeGgfNQCoWkImR14fB99AY.jpg'},
      {'judul': 'Habibie & Ainun', 'url_foto': 'https://image.tmdb.org/t/p/w500/eOdYhBFF7vE5v83KVVQfDEyLgEu.jpg'},
      {'judul': 'Cek Toko Sebelah', 'url_foto': 'https://image.tmdb.org/t/p/w500/ygOPhiygrijDa0E7x2ETWWXE6HP.jpg'},
      {'judul': 'Mencuri Raden Saleh', 'url_foto': 'https://image.tmdb.org/t/p/w500/66yOibmlqxASFoNyEZIORELJqBC.jpg'},
      {'judul': 'Ayat-Ayat Cinta', 'url_foto': 'https://image.tmdb.org/t/p/w500/pWFTabzMwSbso1DsRwE8My4IL1h.jpg'}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: fetchFilms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Tunggu ya, sedang mengambil data film... (5 Detik)'),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final films = snapshot.data!;

          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        films[index]['url_foto']!,
                        width: 80,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            films[index]['judul']!,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 20),
                              SizedBox(width: 4),
                              Text('4.8', style: TextStyle(fontSize: 16, color: Colors.black54)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ---> KIRIM DATA FILM SPESIFIK KE TOMBOL
                    FavoriteButton(film: films[index]), 
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: Text('Tidak ada data film.'));
      },
    );
  }
}