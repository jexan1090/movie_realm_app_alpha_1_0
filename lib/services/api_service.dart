import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_realm_app_alpha_1_0/models/cast.dart';
import 'package:movie_realm_app_alpha_1_0/models/genre.dart';
import 'package:movie_realm_app_alpha_1_0/models/movie.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';

class ApiService {
  static const String _apiKey = '600ca67c0216bce85068ef91ed2744b4';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<dynamic>> fetchTrendingAll(
      String timeWindow, List<Genre> movieGenres, List<Genre> tvGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/trending/all/$timeWindow?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return results
          .map((item) {
            if (item['media_type'] == 'movie') {
              final movie = Movie.fromJson(item);
              movie.assignGenres(movieGenres);
              return movie;
            } else if (item['media_type'] == 'tv') {
              final tvShow = TVShow.fromJson(item);
              tvShow.assignGenres(tvGenres);
              return tvShow;
            }
            return null;
          })
          .whereType<dynamic>()
          .toList();
    } else {
      throw Exception('Failed to fetch trending data');
    }
  }

  static Future<List<Movie>> fetchPopularMovies(
      List<Genre> moviesGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final movies = (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      for (var movie in movies) {
        movie.assignGenres(moviesGenres);
      }

      return movies;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<TVShow>> fetchPopularTVShows(
      List<Genre> tvshowsGenres) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tv/popular?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final tvshows = (data['results'] as List)
          .map((movieJson) => TVShow.fromJson(movieJson))
          .toList();

      for (var tvshow in tvshows) {
        tvshow.assignGenres(tvshowsGenres);
      }

      return tvshows;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<Movie>> fetchTopRatedMovies(
      List<Genre> moviesGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final movies = (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      for (var movie in movies) {
        movie.assignGenres(moviesGenres);
      }

      return movies;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<TVShow>> fetchTopRatedTVShow(
      List<Genre> tvshowsGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/tv/top_rated?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final tvshows = (data['results'] as List)
          .map((movieJson) => TVShow.fromJson(movieJson))
          .toList();

      for (var tvshow in tvshows) {
        tvshow.assignGenres(tvshowsGenres);
      }

      return tvshows;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<Movie>> fetchUpcomingMovies(
      List<Genre> moviesGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final movies = (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      for (var movie in movies) {
        movie.assignGenres(moviesGenres);
      }

      return movies;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<TVShow>> fetchOnTheAirTVShow(
      List<Genre> tvshowsGenres) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/tv/on_the_air?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final tvshows = (data['results'] as List)
          .map((movieJson) => TVShow.fromJson(movieJson))
          .toList();

      for (var tvshow in tvshows) {
        tvshow.assignGenres(tvshowsGenres);
      }

      return tvshows;
    } else {
      throw Exception('Something Happened');
    }
  }

  static Future<List<Genre>> fetchGenresMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList();
    } else {
      throw Exception('Failed to fetch genres');
    }
  }

  static Future<List<Genre>> fetchGenresTVShows() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genre/tv/list?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList();
    } else {
      throw Exception('Failed to fetch genres');
    }
  }

  static Future<List<Cast>> fetchMovieCast(int movieId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final castList =
          (data['cast'] as List).map((cast) => Cast.fromJson(cast)).toList();
      return castList;
    } else {
      throw Exception('Failed to load cast data');
    }
  }

  static Future<List<Cast>> fetchTVShowCast(int tvshowId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/tv/$tvshowId/credits?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final castList =
          (data['cast'] as List).map((cast) => Cast.fromJson(cast)).toList();
      return castList;
    } else {
      throw Exception('Failed to load cast data');
    }
  }

  static Future<Movie> fetchMovieById(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  static Future<TVShow> fetchTVShowById(int tvshowId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tv/$tvshowId?api_key=$_apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TVShow.fromJson(data);
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  static Future<List<dynamic>> searchItems(String query, int? genreId) async {
    final url = Uri.parse(
        '$_baseUrl/search/multi?api_key=$_apiKey&query=$query&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];

      if (genreId != null) {
        results = results.where((item) {
          return item['genre_ids'] != null &&
              item['genre_ids'].contains(genreId);
        }).toList();
      }

      return results;
    } else {
      throw Exception('Failed to fetch search results');
    }
  }
}
