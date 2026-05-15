import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/core/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:movie_app/features/movies/presentation/blocs/favorites/favorites_bloc.dart';

import '../widgets/build_drawer.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  const MovieDetails({super.key, required this.movie});

  static const genresMap = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    18: "Drama",
    27: "Horror",
    53: "Thriller",
    10751: "Family",
  };

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(GetSimilarMoviesEvent(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.movie.posterPath.isNotEmpty
        ? "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"
        : null;

    return Scaffold(
      drawer: buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          /// ================= APP BAR =================
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: posterUrl != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.fitHeight,
                        ),

                        /// Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        /// TITLE + HEART
                        BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, state) {
                            final isFav = state.favorites.any(
                              (m) => m.id == widget.movie.id,
                            );

                            return Positioned(
                              bottom: 20,
                              left: 16,
                              right: 16,
                              child: Row(
                                children: [
                                  /// TITLE
                                  Expanded(
                                    child: Text(
                                      widget.movie.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  /// HEART
                                  GestureDetector(
                                    onTap: () {
                                      context.read<FavoritesBloc>().add(
                                        ToggleFavoriteEvent(widget.movie),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(color: Colors.grey),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP INFO
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: posterUrl,
                            height: 160,
                          ),
                        ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${widget.movie.voteAverage}/10",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Release: ${widget.movie.releaseDate}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// GENRES
                  Wrap(
                    spacing: 8,
                    children: widget.movie.genreIds.map((id) {
                      return Chip(
                        backgroundColor: Colors.white10,
                        label: Text(
                          MovieDetails.genresMap[id] ?? "Unknown",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  /// OVERVIEW
                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.movie.overview,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  /// WATCH BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final url = Uri.parse(
                          "https://www.themoviedb.org/movie/${widget.movie.id}",
                        );
                        await launchUrl(url);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Watch Now"),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// SIMILAR
                  const Text(
                    "Similar Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  BlocBuilder<MoviesBloc, MoviesState>(
                    builder: (context, state) {
                      if (state.isLoadingSimilar) {
                        return const LoadingWidget();
                      }

                      final movies = state.similarMovies;

                      if (movies.isEmpty) {
                        return const Text(
                          "No similar movies",
                          style: TextStyle(color: Colors.white70),
                        );
                      }

                      return SizedBox(
                        height: 190,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final m = movies[index];

                            final img = m.posterPath.isNotEmpty
                                ? "https://image.tmdb.org/t/p/w200${m.posterPath}"
                                : null;

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MovieDetails(movie: m),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: img != null
                                          ? CachedNetworkImage(
                                              imageUrl: img,
                                              height: 140,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: 140,
                                              width: 120,
                                              color: Colors.grey,
                                            ),
                                    ),

                                    const SizedBox(height: 6),

                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        m.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
