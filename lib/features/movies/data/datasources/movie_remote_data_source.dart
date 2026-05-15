import 'package:dio/dio.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<List<MovieModel>> searchMovies(String query);
  Future<List<MovieModel>> getSimilarMovies(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MovieModel>> getPopularMovies(int page) async {
    final response = await dio.get(
      "/movie/popular",
      queryParameters: {"api_key": ApiConstants.apiKey, "page": page},
    );

    final List results = response.data['results'] ?? [];

    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dio.get(
      "/search/movie",
      queryParameters: {"api_key": ApiConstants.apiKey, "query": query},
    );

    final List results = response.data['results'] ?? [];

    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    final response = await dio.get(
      "/movie/$movieId/similar",
      queryParameters: {"api_key": ApiConstants.apiKey},
    );

    final List results = response.data['results'] ?? [];

    return results.map((e) => MovieModel.fromJson(e)).toList();
  }
}
