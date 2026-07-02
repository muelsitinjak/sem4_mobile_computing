import 'package:flutter/material.dart';
import 'favorites_manager.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    // KUNCI PERBAIKAN: Ambil data langsung dari List, TANPA .value atau ValueListenable
    final favoriteFilms = FavoritesManager.favoriteFilms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Favorit Saya'),
        backgroundColor: Colors.redAccent,
      ),
      body: favoriteFilms.isEmpty
          ? const Center(
              child: Text(
                'Belum ada film favorit.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteFilms.length,
              itemBuilder: (context, index) {
                final film = favoriteFilms[index];
                return ListTile(
                  leading: ClipRRect( // Akses data dengan aman
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      // Gunakan null-aware operator dan berikan nilai default
                      film['url_foto'] as String? ?? '', 
                      width: 50, 
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 70,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      }
                    ),
                  ),
                  // Akses judul dengan aman
                  title: Text(film['judul'] as String? ?? 'No Title'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Hapus langsung dari List menggunakan judul
                      setState(() {
                        // Logika penghapusan tetap sama
                        FavoritesManager.favoriteFilms.removeWhere((f) => f['judul'] == film['judul']);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}