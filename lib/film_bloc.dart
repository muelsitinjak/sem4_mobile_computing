import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_repository.dart';

// --- EVENT ---
abstract class FilmEvent {}
class LoadFilms extends FilmEvent {}
class SearchFilms extends FilmEvent {
  final String query;
  SearchFilms(this.query);
}

// --- STATE ---
abstract class FilmState {}
class FilmLoading extends FilmState {}
class FilmLoaded extends FilmState {
  final List<Map<String, dynamic>> films;
  FilmLoaded(this.films);
}
class FilmError extends FilmState {
  final String message;
  FilmError(this.message);
}

// --- BLOC ---
class FilmBloc extends Bloc<FilmEvent, FilmState> {
  final MovieRepository repository;
  
  // Variabel untuk menyimpan master data agar tidak perlu memanggil API terus menerus saat mencari
  List<Map<String, dynamic>> _allFilms = [];

  FilmBloc(this.repository) : super(FilmLoading()) {
    
    // Event 1: Memuat Film dari Repository
    on<LoadFilms>((event, emit) async {
      emit(FilmLoading());
      try {
        _allFilms = await repository.getMovies();
        if (_allFilms.isEmpty) {
          emit(FilmError("Tidak ada data tersimpan, mohon nyalakan internet."));
        } else {
          emit(FilmLoaded(_allFilms));
        }
      } catch (e) {
        emit(FilmError("Terjadi kesalahan: $e"));
      }
    });

    // Event 2: Mencari Film (Logika dipindah dari UI ke sini)
    on<SearchFilms>((event, emit) {
      if (event.query.isEmpty) {
        emit(FilmLoaded(_allFilms));
      } else {
        final filteredFilms = _allFilms.where((film) {
          final judul = film['judul'].toString().toLowerCase();
          return judul.contains(event.query.toLowerCase());
        }).toList();
        
        emit(FilmLoaded(filteredFilms));
      }
    });
  }
}