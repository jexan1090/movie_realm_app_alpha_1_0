import 'package:movie_realm_app_alpha_1_0/models/genre.dart';

class Movie {
  final int id;
  final String backdropPath;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final List<int> genreIds;
  List<Genre> genres = [];

  Movie({
    required this.id,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      backdropPath: json['backdrop_path'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds:
          json['genre_ids'] != null ? List<int>.from(json['genre_ids']) : [],
    );
  }

  void assignGenres(List<Genre> moviesGenres) {
    genres = genreIds
        .map((id) => moviesGenres.firstWhere(
              (genre) => genre.id == id,
              orElse: () => Genre(id: id, name: 'Unknown'),
            ))
        .toList();
  }
}
