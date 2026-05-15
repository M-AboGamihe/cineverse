import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'movie_list_widget.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search movies...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          context.read<MoviesBloc>().add(ClearSearchEvent());
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        context.read<MoviesBloc>().add(ClearSearchEvent());
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      context.read<MoviesBloc>().add(SearchMoviesEvent(query));
    }

    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        if (state.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (query.isEmpty) {
          // Show popular titles when there is no query yet
          return MovieListWidget(
            movies: state.movies,
            hasReachedMax: true,
            controller: ScrollController(),
          );
        }

        if (state.searchMovies.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        return MovieListWidget(
          movies: state.searchMovies,
          hasReachedMax: true,
          controller: ScrollController(),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
