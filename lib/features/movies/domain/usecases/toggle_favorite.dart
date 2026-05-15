import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

class ToggleFavoriteUseCase {
  final MovieRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(Movie movie) async {
    return await repository.toggleFavorite(movie);
  }
}
