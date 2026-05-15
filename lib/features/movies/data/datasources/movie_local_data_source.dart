import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheMovies(List<MovieModel> movies, int page);
  Future<List<MovieModel>> getCachedMovies(int page);
  Future<void> clearCache();

  // Favorites
  Future<void> toggleFavorite(MovieModel movie);
  Future<bool> isFavorite(int movieId);
  Future<List<MovieModel>> getFavorites();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box cacheBox;
  final Box favoritesBox;

  MovieLocalDataSourceImpl({
    required this.cacheBox,
    required this.favoritesBox,
  });

  @override
  Future<void> cacheMovies(List<MovieModel> movies, int page) async {
    await cacheBox.put(
      'popular_page_$page',
      movies.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<MovieModel>> getCachedMovies(int page) async {
    final data = cacheBox.get('popular_page_$page');

    if (data != null) {
      return (data as List)
          .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  @override
  Future<void> clearCache() async {
    await cacheBox.clear();
  }

  @override
  Future<void> toggleFavorite(MovieModel movie) async {
    final key = movie.id.toString();
    if (favoritesBox.containsKey(key)) {
      await favoritesBox.delete(key);
    } else {
      await favoritesBox.put(key, movie.toJson());
    }
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return favoritesBox.containsKey(movieId.toString());
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    final favorites = favoritesBox.values.toList();
    return favorites
        .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
