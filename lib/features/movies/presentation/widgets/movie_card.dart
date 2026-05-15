import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.width = 120,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: width,
                  height: height,
                  color: Colors.grey,
                  child: const Icon(Icons.movie),
                ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: width,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
