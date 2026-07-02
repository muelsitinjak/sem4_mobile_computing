import 'package:flutter/material.dart';
import 'favorites_manager.dart';

class FavoriteButton extends StatefulWidget {
  // Mengubah tipe data agar sesuai dengan data dari BLoC (Map<String, dynamic>)
  final Map<String, dynamic> film;

  const FavoriteButton({super.key, required this.film});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    // Mengecek kesamaan berdasarkan JUDUL film
    final isFavorite = FavoritesManager.favoriteFilms
        .any((f) => f['judul'] == widget.film['judul']);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 30.0,
      ),
      onPressed: () {
        setState(() {
          if (isFavorite) {
            FavoritesManager.favoriteFilms
                .removeWhere((f) => f['judul'] == widget.film['judul']);
          } else {
            FavoritesManager.favoriteFilms.add(widget.film);
          }
        });
      },
    );
  }
}