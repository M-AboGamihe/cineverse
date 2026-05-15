import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/core/constants/app_constants.dart';
import 'package:movie_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:movie_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:movie_app/features/authentication/domain/usecases/login_use_case.dart';
import 'package:movie_app/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:movie_app/features/authentication/domain/usecases/register_use_case.dart';
import 'package:movie_app/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movie_app/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:movie_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_app/features/movies/domain/usecases/check_if_favorite.dart';
import 'package:movie_app/features/movies/domain/usecases/get_favorites.dart';
import 'package:movie_app/features/movies/domain/usecases/get_popular_movie_use_case.dart';
import 'package:movie_app/features/movies/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movie_app/features/movies/domain/usecases/search_movies_use_case.dart';
import 'package:movie_app/features/movies/domain/usecases/toggle_favorite.dart';
import 'package:movie_app/features/movies/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:movie_app/features/movies/presentation/blocs/movies/movies_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)),
  );
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      cacheBox: Hive.box('moviesBox'),
      favoritesBox: Hive.box('favoritesBox'),
    ),
  );

  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetSimilarMoviesUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));

  sl.registerLazySingleton(() => GetPopularMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => CheckIfFavoriteUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MoviesBloc(
      sl<GetPopularMoviesUseCase>(),
      sl<SearchMoviesUseCase>(),
      sl<GetSimilarMoviesUseCase>(),
    ),
  );

  sl.registerFactory(
    () => FavoritesBloc(
      getFavoritesUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      checkIfFavoriteUseCase: sl(),
    ),
  );
}
