import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

class GetFavoritesUseCase {
  final MovieRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Movie>>> call() async {
    return await repository.getFavorites();
  }
}
