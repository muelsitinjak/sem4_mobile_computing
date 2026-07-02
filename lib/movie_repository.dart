import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart'; // <--- 1. TAMBAHKAN IMPORT INI

class MovieRepository {
  final Dio _dio = Dio();
  final String _boxName = 'movie_cache';
  // 1. Definisikan base URL dan API Key secara terpisah untuk kejelasan
  final String _apiKey = '76310231f98a7eda9cfb103a655282e0';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Map<String, dynamic>>> getMovies() async {
    // 2. MODIFIKASI PENGECEKAN INTERNET
    bool hasInternet = true; // Secara default anggap internet menyala
    
    // Jika aplikasi berjalan BUKAN di Web (artinya di HP), baru lakukan pengecekan asli
    if (!kIsWeb) {
      hasInternet = await InternetConnectionChecker().hasConnection;
    }

    var box = Hive.box(_boxName);

    if (hasInternet) {
      try {
        // 3. Panggil URL yang benar dan tambahkan API Key sebagai query parameter
        final response = await _dio.get('$_baseUrl/movie/popular',
            queryParameters: {'api_key': _apiKey}
        );
        
        final List<dynamic> rawMovies = response.data['results'];
        
        // 4. Perbaiki pemetaan data agar konsisten dan type-safe
        final List<Map<String, dynamic>> formattedMovies = rawMovies.map((m) => {
          'judul': m['title']?.toString() ?? 'Tanpa Judul',
          'url_foto': 'https://image.tmdb.org/t/p/w500${m['poster_path']}',
          // Simpan rating sebagai angka (num) untuk fleksibilitas
          'rating': m['vote_average'] ?? 0.0,
          // Gunakan 'overview' agar cocok dengan DetailPage
          'overview': m['overview']?.toString() ?? 'Tidak ada deskripsi',
          'release_date': m['release_date']?.toString() ?? 'Unknown'
        }).toList();
        
        box.put('movies_data', formattedMovies);
        
        return formattedMovies;
      } catch (e) {
        // 5. Ganti print() dengan logging error yang lebih informatif
        debugPrint("Gagal mengambil data dari API, memuat dari cache: $e");
        return _getCachedMovies(box);
      }
    } else {
      return _getCachedMovies(box);
    }
  }

  List<Map<String, dynamic>> _getCachedMovies(Box box) {
    final cachedData = box.get('movies_data', defaultValue: []);
    return List<Map<String, dynamic>>.from(
      cachedData.map((e) => Map<String, dynamic>.from(e))
    );
  }
}