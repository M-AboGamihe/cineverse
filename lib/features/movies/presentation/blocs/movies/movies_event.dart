part of 'movies_bloc.dart';

sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

/// Fetch popular movies
class GetPopularMoviesEvent extends MoviesEvent {}

/// Refresh movies list
class RefreshMoviesEvent extends MoviesEvent {}

/// Load more movies (pagination)
class LoadMoreMoviesEvent extends MoviesEvent {}

/// Search movies
class SearchMoviesEvent extends MoviesEvent {
  final String query;
  const SearchMoviesEvent(this.query);
  @override
  List<Object> get props => [query];
}

/// Clear search results
class ClearSearchEvent extends MoviesEvent {}

/// Get similar movies
class GetSimilarMoviesEvent extends MoviesEvent {
  final int movieId;
  const GetSimilarMoviesEvent(this.movieId);
  @override
  List<Object> get props => [movieId];
}

/// Toggle favorite movie
class ToggleFavoriteMovieEvent extends MoviesEvent {
  final Movie movie;
  const ToggleFavoriteMovieEvent(this.movie);
  @override
  List<Object> get props => [movie];
}
