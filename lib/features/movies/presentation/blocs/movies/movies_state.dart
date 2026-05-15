part of 'movies_bloc.dart';

enum MoviesStatus { initial, loading, success, error, refreshing }

class MoviesState extends Equatable {
  final List<Movie> movies;
  final List<Movie> searchMovies;
  final List<Movie> favoriteMovies;
  final int page;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final MoviesStatus status;
  final String? message;
  final Set<int> loadedPages;
  final bool isSearching;
  final String searchQuery;
  final List<Movie> similarMovies;
  final bool isLoadingSimilar;

  const MoviesState({
    this.movies = const [],
    this.searchMovies = const [],
    this.favoriteMovies = const [],
    this.page = 1,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.status = MoviesStatus.initial,
    this.message,
    this.loadedPages = const {},
    this.isSearching = false,
    this.searchQuery = '',
    this.similarMovies = const [],
    this.isLoadingSimilar = false,
  });

  MoviesState copyWith({
    List<Movie>? movies,
    List<Movie>? searchMovies,
    List<Movie>? favoriteMovies,
    int? page,
    bool? isLoadingMore,
    bool? hasReachedMax,
    MoviesStatus? status,
    String? message,
    Set<int>? loadedPages,
    bool? isSearching,
    String? searchQuery,
    List<Movie>? similarMovies,
    bool? isLoadingSimilar,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      searchMovies: searchMovies ?? this.searchMovies,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      message: message ?? this.message,
      loadedPages: loadedPages ?? this.loadedPages,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      similarMovies: similarMovies ?? this.similarMovies,
      isLoadingSimilar: isLoadingSimilar ?? this.isLoadingSimilar,
    );
  }

  @override
  List<Object?> get props => [
    movies,
    searchMovies,
    favoriteMovies,
    page,
    isLoadingMore,
    hasReachedMax,
    status,
    message,
    loadedPages,
    isSearching,
    searchQuery,
    similarMovies,
    isLoadingSimilar,
  ];
}
