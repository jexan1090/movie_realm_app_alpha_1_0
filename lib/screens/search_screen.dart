import 'package:flutter/material.dart';
import 'package:movie_realm_app_alpha_1_0/models/genre.dart';
import 'package:movie_realm_app_alpha_1_0/models/movie.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';
import 'package:movie_realm_app_alpha_1_0/screens/movie_detail_screen.dart';
import 'package:movie_realm_app_alpha_1_0/screens/tvshow_detail_screen.dart';
import 'package:movie_realm_app_alpha_1_0/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  List<Genre> genres = [];
  Genre? selectedGenre;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      final fetchedGenresMovies = await ApiService.fetchGenresMovies();
      final fetchedGenresTVShows = await ApiService.fetchGenresTVShows();

      setState(() {
        genres = [...fetchedGenresMovies, ...fetchedGenresTVShows];
      });
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }

  Future<void> _searchContent(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final results = await ApiService.searchItems(query, selectedGenre?.id);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching content: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Search Movies & TV Shows',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _searchContent(value);
                    },
                    onSubmitted: (value) {
                      _searchContent(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: DropdownButtonFormField<Genre>(
                        value: selectedGenre,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: genres
                            .map((genre) => DropdownMenuItem(
                                  value: genre,
                                  child: Text(genre.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGenre = value;
                          });
                          _searchContent(searchController.text);
                        },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchResults.isEmpty)
              const Center(
                  child: Text(
                'No results found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          if (item['media_type'] == 'movie') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  movie: Movie.fromJson(item),
                                  onFavoriteChanged: () {},
                                ),
                              ),
                            );
                          } else if (item['media_type'] == 'tv') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TVShowDetailScreen(
                                  tvshow: TVShow.fromJson(item),
                                  onFavoriteChanged: () {},
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: item['poster_path'] != null
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w200${item['poster_path']}',
                                        width: 120,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.movie, size: 120),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] ??
                                          item['name'] ??
                                          'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['release_date'] ??
                                          item['first_air_date'] ??
                                          'Unknown',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['overview'] ??
                                          'No overview available.',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
