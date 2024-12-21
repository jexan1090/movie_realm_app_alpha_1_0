import 'package:movie_realm_app_alpha_1_0/models/genre.dart';

class TVShow {
  final int id;
  final String backdropPath;
  final String originalName;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final List<int> genreIds;
  List<Genre> genres = [];

  TVShow({
    required this.id,
    required this.backdropPath,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.genreIds,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      id: json['id'],
      backdropPath: json['backdrop_path'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      name: json['name'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      genreIds:
          json['genre_ids'] != null ? List<int>.from(json['genre_ids']) : [],
    );
  }

  void assignGenres(List<Genre> tvshowsGenres) {
    genres = genreIds
        .map((id) => tvshowsGenres.firstWhere(
              (genre) => genre.id == id,
              orElse: () => Genre(id: id, name: 'Unknown'),
            ))
        .toList();
  }
}
