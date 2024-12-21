import 'package:flutter/material.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';

class TVShowCard extends StatelessWidget {
  final TVShow tvshow;

  const TVShowCard({super.key, required this.tvshow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${tvshow.posterPath}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
