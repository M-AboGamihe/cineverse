part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Movie movie;
  const ToggleFavoriteEvent(this.movie);

  @override
  List<Object?> get props => [movie];
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  final int movieId;
  const CheckFavoriteStatusEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  const RemoveFavoriteEvent(this.movie);

  @override
  List<Object> get props => [movie];
}
