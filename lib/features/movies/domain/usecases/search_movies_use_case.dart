import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

class SearchMoviesUseCase {
  final MovieRepository repository;

  SearchMoviesUseCase(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) async {
    if (query.trim().isEmpty) return const Right([]);
    return await repository.searchMovies(query);
  }
}
