import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/widgets/loading_widget.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/presentation/screens/movie_details.dart';

class MovieListWidget extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController controller;
  final bool hasReachedMax;

  const MovieListWidget({
    super.key,
    required this.movies,
    required this.controller,
    required this.hasReachedMax,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      cacheExtent: 1000,
      padding: const EdgeInsets.all(3),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: hasReachedMax ? movies.length : movies.length + 1,
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          return LoadingWidget();
        }

        final movie = movies[index];

        final imageUrl = movie.posterPath.isNotEmpty
            ? "https://image.tmdb.org/t/p/w300${movie.posterPath}"
            : null;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MovieDetails(movie: movie)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          memCacheWidth: 300,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey.shade300),
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.grey),
                        )
                      : Container(
                          color: Colors.grey,
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  movie.title,
                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
