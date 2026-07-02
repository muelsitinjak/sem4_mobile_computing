import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Wajib import
import 'package:hive_flutter/hive_flutter.dart'; // Wajib import

import 'favorite_button.dart';
import 'favorites_page.dart';
import 'detail_page.dart';
import 'movie_repository.dart';
import 'film_bloc.dart';

void main() async {
  // Inisialisasi Local Storage (Hive) sebelum aplikasi berjalan
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('movie_cache');

  // Deklarasi Repository
  final movieRepository = MovieRepository();

  runApp(
    // Membungkus aplikasi dengan BlocProvider
    BlocProvider(
      create: (context) => FilmBloc(movieRepository)..add(LoadFilms()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Karena State dan Logika sudah diurus BLoC, kita bisa pakai StatelessWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Film TMDB'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_sharp, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // KOTAK INPUT PENCARIAN
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              // Trigger event SearchFilms ke BLoC saat user mengetik
              onChanged: (value) => context.read<FilmBloc>().add(SearchFilms(value)),
              decoration: InputDecoration(
                labelText: 'Cari Film...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          
          // DAFTAR FILM MENGGUNAKAN BLOCBUILDER
          Expanded(
            child: BlocBuilder<FilmBloc, FilmState>(
              builder: (context, state) {
                if (state is FilmLoading) {
                  return const Center(child: CircularProgressIndicator());
                } 
                else if (state is FilmError) {
                  return Center(child: Text(state.message));
                } 
                else if (state is FilmLoaded) {
                  final films = state.films;

                  if (films.isEmpty) {
                    return const Center(child: Text('Film tidak ditemukan.'));
                  }

                  return ListView.builder(
                    itemCount: films.length,
                    itemBuilder: (context, index) {
                      final film = films[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(film: film),
                            ),
                          );
                        },
                        child: Container(
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
                                  // Akses data dengan aman, berikan nilai default jika null
                                  film['url_foto'] as String? ?? '',
                                  width: 80,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  // Tampilkan placeholder jika gambar gagal dimuat atau URL kosong
                                  errorBuilder: (context, error, stackTrace) => Container(
                                      width: 80, height: 110, color: Colors.grey[300], 
                                      child: const Icon(Icons.movie, color: Colors.grey)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text( // Akses judul dengan aman
                                      film['judul'] as String? ?? 'No Title',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.orange, size: 20),
                                        const SizedBox(width: 4),
                                        // Pastikan rating dikonversi ke String untuk ditampilkan
                                        Text((film['rating'] ?? 'N/A').toString(), 
                                          style: const TextStyle(fontSize: 16, color: Colors.black54)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              FavoriteButton(film: film),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox(); // Fallback UI kosong
              },
            ),
          ),
        ],
      ),
    );
  }
}