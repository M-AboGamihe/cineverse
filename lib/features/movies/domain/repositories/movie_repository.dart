import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId);

  // Favorites
  Future<Either<Failure, void>> toggleFavorite(Movie movie);
  Future<Either<Failure, bool>> isFavorite(int movieId);
  Future<Either<Failure, List<Movie>>> getFavorites();
}
