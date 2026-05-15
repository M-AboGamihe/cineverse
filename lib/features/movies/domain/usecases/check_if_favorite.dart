import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

class CheckIfFavoriteUseCase {
  final MovieRepository repository;

  CheckIfFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(int movieId) async {
    return await repository.isFavorite(movieId);
  }
}
