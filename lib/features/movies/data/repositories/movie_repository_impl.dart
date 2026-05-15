import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

bool _isLikelyNoConnection(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return true;
    case DioExceptionType.badCertificate:
      return true;
    case DioExceptionType.unknown:
      return e.error is SocketException;
    default:
      return false;
  }
}

bool _isInvalidTmdbKey(DioException e) {
  final code = e.response?.statusCode;
  if (code == 401 || code == 403) return true;
  final data = e.response?.data;
  if (data is Map && data['status_code'] == 7) return true;
  return false;
}

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies(int page) async {
    try {
      final remoteData = await remoteDataSource.getPopularMovies(page);
      await localDataSource.cacheMovies(remoteData, page);
      return Right(remoteData.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      if (_isInvalidTmdbKey(e)) {
        return Left(
          ServerFailure(
            'Missing or invalid TMDB API key. Run with '
            '--dart-define=TMDB_API_KEY=your_key',
          ),
        );
      }
      if (_isLikelyNoConnection(e)) {
        final cached = await localDataSource.getCachedMovies(page);
        if (cached.isNotEmpty) {
          return Right(cached.map((e) => e.toEntity()).toList());
        }
        return const Left(OfflineFailure(''));
      }
      final cached = await localDataSource.getCachedMovies(page);
      if (cached.isNotEmpty) {
        return Right(cached.map((e) => e.toEntity()).toList());
      }
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      final cached = await localDataSource.getCachedMovies(page);
      if (cached.isNotEmpty) {
        return Right(cached.map((e) => e.toEntity()).toList());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final remote = await remoteDataSource.searchMovies(query);
      return Right(remote.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      if (_isInvalidTmdbKey(e)) {
        return Left(
          ServerFailure(
            'Missing or invalid TMDB API key. Run with '
            '--dart-define=TMDB_API_KEY=your_key',
          ),
        );
      }
      if (_isLikelyNoConnection(e)) {
        return const Left(OfflineFailure(''));
      }
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getSimilarMovies(int movieId) async {
    try {
      final data = await remoteDataSource.getSimilarMovies(movieId);
      return Right(data.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      if (_isInvalidTmdbKey(e)) {
        return Left(
          ServerFailure(
            'Missing or invalid TMDB API key. Run with '
            '--dart-define=TMDB_API_KEY=your_key',
          ),
        );
      }
      if (_isLikelyNoConnection(e)) {
        return const Left(OfflineFailure(''));
      }
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Movie movie) async {
    try {
      final model = MovieModel(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        voteAverage: movie.voteAverage,
        releaseDate: movie.releaseDate,
        genreIds: movie.genreIds,
      );
      await localDataSource.toggleFavorite(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to toggle favorite: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int movieId) async {
    try {
      final result = await localDataSource.isFavorite(movieId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure("Failed to check favorite: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavorites() async {
    try {
      final result = await localDataSource.getFavorites();
      return Right(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure("Failed to get favorites: ${e.toString()}"));
    }
  }
}
