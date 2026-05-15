import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/usecases/check_if_favorite.dart';
import 'package:movie_app/features/movies/domain/usecases/get_favorites.dart';
import 'package:movie_app/features/movies/domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final CheckIfFavoriteUseCase checkIfFavoriteUseCase;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.checkIfFavoriteUseCase,
  }) : super(const FavoritesState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<CheckFavoriteStatusEvent>(_onCheckFavoriteStatus);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await getFavoritesUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (movies) => emit(state.copyWith(isLoading: false, favorites: movies)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await toggleFavoriteUseCase(event.movie);
    result.fold((failure) => emit(state.copyWith(error: failure.message)), (_) {
      add(LoadFavoritesEvent());
    });
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatusEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    // With the new state, we don't necessarily need this,
    // we can just check if state.favorites contains the movie.
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await toggleFavoriteUseCase(event.movie);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => add(LoadFavoritesEvent()),
    );
  }
}
