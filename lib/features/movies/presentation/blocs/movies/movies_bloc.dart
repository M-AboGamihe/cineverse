import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/usecases/get_popular_movie_use_case.dart';
import 'package:movie_app/features/movies/domain/usecases/search_movies_use_case.dart';
import 'package:movie_app/features/movies/domain/usecases/get_similar_movies_use_case.dart';

import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/core/strings/failures.dart';

part 'movies_event.dart';
part 'movies_state.dart';

/// ================= Debounce =================
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMoviesUseCase getPopularMovies;
  final SearchMoviesUseCase searchMovies;
  final GetSimilarMoviesUseCase getSimilarMovies;

  MoviesBloc(this.getPopularMovies, this.searchMovies, this.getSimilarMovies)
    : super(const MoviesState()) {
    on<GetPopularMoviesEvent>(_onGetPopular);
    on<RefreshMoviesEvent>(_onRefresh);
    on<LoadMoreMoviesEvent>(_onLoadMore, transformer: sequential());

    on<SearchMoviesEvent>(
      _onSearchMovies,
      transformer: debounce(const Duration(milliseconds: 500)),
    );

    on<ClearSearchEvent>(_onClearSearch);
    on<GetSimilarMoviesEvent>(_onGetSimilarMovies);
    on<ToggleFavoriteMovieEvent>(_onToggleFavorite);
  }

  // =========================================================
  // Shared handler for network-backed requests
  // =========================================================
  Future<void> _runRequest({
    required Future<dynamic> Function() request,
    required Emitter<MoviesState> emit,
    required Function(List<Movie> data) onSuccess,
    MoviesStatus loadingStatus = MoviesStatus.loading,
    bool setLoading = true,
  }) async {
    if (setLoading) {
      emit(state.copyWith(status: loadingStatus));
    }

    final result = await request();

    result.fold((failure) {
      emit(
        state.copyWith(
          status: MoviesStatus.error,
          message: _mapFailureToMessage(failure),
        ),
      );
    }, (data) => onSuccess(data));
  }

  // =========================================================
  // POPULAR
  // =========================================================
  Future<void> _onGetPopular(
    GetPopularMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    await _runRequest(
      request: () => getPopularMovies(1),
      emit: emit,
      loadingStatus: state.movies.isEmpty
          ? MoviesStatus.loading
          : MoviesStatus.success,
      onSuccess: (movies) {
        emit(
          state.copyWith(
            status: MoviesStatus.success,
            movies: movies,
            page: 1,
            hasReachedMax: movies.isEmpty,
            loadedPages: {1},
          ),
        );
      },
    );
  }

  // =========================================================
  // REFRESH
  // =========================================================
  Future<void> _onRefresh(
    RefreshMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    await _runRequest(
      request: () => getPopularMovies(1),
      emit: emit,
      loadingStatus: MoviesStatus.refreshing,
      onSuccess: (movies) {
        emit(
          state.copyWith(
            status: MoviesStatus.success,
            movies: movies,
            page: 1,
            hasReachedMax: movies.isEmpty,
            loadedPages: {1},
          ),
        );
      },
    );
  }

  // =========================================================
  // LOAD MORE
  // =========================================================
  Future<void> _onLoadMore(
    LoadMoreMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    final nextPage = state.page + 1;

    if (state.loadedPages.contains(nextPage)) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getPopularMovies(nextPage);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          message: _mapFailureToMessage(failure),
        ),
      ),
      (movies) {
        final existingIds = state.movies.map((e) => e.id).toSet();

        final newMovies = movies
            .where((m) => !existingIds.contains(m.id))
            .toList();

        emit(
          state.copyWith(
            movies: [...state.movies, ...newMovies],
            page: nextPage,
            isLoadingMore: false,
            hasReachedMax: movies.isEmpty,
            loadedPages: {...state.loadedPages, nextPage},
          ),
        );
      },
    );
  }

  // =========================================================
  // SEARCH
  // =========================================================
  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(
        state.copyWith(searchMovies: [], searchQuery: '', isSearching: false),
      );
      return;
    }

    emit(state.copyWith(isSearching: true, searchQuery: query));

    await _runRequest(
      request: () => searchMovies(query),
      emit: emit,
      loadingStatus: MoviesStatus.success,
      setLoading: false,
      onSuccess: (movies) {
        emit(state.copyWith(isSearching: false, searchMovies: movies));
      },
    );
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<MoviesState> emit) {
    emit(state.copyWith(searchMovies: [], searchQuery: '', isSearching: false));
  }

  // =========================================================
  // SIMILAR
  // =========================================================
  Future<void> _onGetSimilarMovies(
    GetSimilarMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(isLoadingSimilar: true));

    final result = await getSimilarMovies(event.movieId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingSimilar: false,
          message: _mapFailureToMessage(failure),
        ),
      ),
      (movies) =>
          emit(state.copyWith(isLoadingSimilar: false, similarMovies: movies)),
    );
  }

  // =========================================================
  // FAVORITES
  // =========================================================
  void _onToggleFavorite(
    ToggleFavoriteMovieEvent event,
    Emitter<MoviesState> emit,
  ) {
    final updated = List<Movie>.from(state.favoriteMovies);

    final index = updated.indexWhere((m) => m.id == event.movie.id);

    if (index >= 0) {
      updated.removeAt(index);
    } else {
      updated.add(event.movie);
    }

    emit(state.copyWith(favoriteMovies: updated));
  }

  // =========================================================
  // ERROR HANDLER
  // =========================================================
  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure f:
        final msg = f.message.trim();
        if (msg.isNotEmpty) return msg;
        return serverFailureMessage;
      case EmptyCacheFailure _:
        return emptyCacheFailureMessage;
      case OfflineFailure _:
        return offlineFailureMessage;
      default:
        return "Unexpected Error";
    }
  }
}
