import 'package:flutter/material.dart';

import 'favorite_button.dart';

class DetailPage extends StatelessWidget {
  // Menerima data film dalam bentuk Map<String, dynamic> untuk type safety yang lebih baik.
  final Map<String, dynamic> film;

  const DetailPage({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari map dengan aman, memberikan nilai default jika null.
    final String title = film['judul'] as String? ?? 'No Title';
    final String imageUrl = film['url_foto'] as String? ?? '';
    // Rating bisa jadi double atau int, jadi kita konversi ke String untuk ditampilkan.
    final String rating = (film['rating'] ?? 'N/A').toString();
    final String overview = film['overview'] as String? ?? 'No overview available.';
    final String releaseDate = film['release_date'] as String? ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Tombol favorit juga memerlukan data film.
          // Pastikan FavoriteButton juga diupdate untuk menerima Map<String, dynamic>.
          FavoriteButton(film: film),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Film
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 100, color: Colors.grey),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, size: 100, color: Colors.grey),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Film
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Rating dan Tanggal Rilis
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 24),
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        releaseDate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sinopsis
                  Text(
                    'Sinopsis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    overview,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}