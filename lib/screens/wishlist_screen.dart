import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_realm_app_alpha_1_0/models/movie.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';
import 'package:movie_realm_app_alpha_1_0/services/api_service.dart';
import 'package:movie_realm_app_alpha_1_0/screens/movie_detail_screen.dart';
import 'package:movie_realm_app_alpha_1_0/screens/tvshow_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with SingleTickerProviderStateMixin {
  List<Movie> wishlistMovies = [];
  List<TVShow> wishlistTVShows = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadWishlist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMovieIds = prefs.getStringList('wishlist_movies') ?? [];
    final favoriteTVShowIds = prefs.getStringList('wishlist_tvshows') ?? [];

    List<Movie> loadedMovies = [];
    List<TVShow> loadedTVShows = [];

    for (String movieId in favoriteMovieIds) {
      try {
        final movie = await ApiService.fetchMovieById(int.parse(movieId));
        loadedMovies.add(movie);
      } catch (e) {
        print("Error loading movie with id $movieId: $e");
      }
    }

    for (String tvshowId in favoriteTVShowIds) {
      try {
        final tvshow = await ApiService.fetchTVShowById(int.parse(tvshowId));
        loadedTVShows.add(tvshow);
      } catch (e) {
        print("Error loading TV show with id $tvshowId: $e");
      }
    }

    setState(() {
      wishlistMovies = loadedMovies;
      wishlistTVShows = loadedTVShows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Your Wishlist',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          tabs: const [
            Tab(
                icon: Icon(
                  Icons.movie,
                ),
                text: "Movies"),
            Tab(
                icon: Icon(
                  Icons.tv,
                ),
                text: "TV Shows"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieTab(),
          _buildTVShowTab(),
        ],
      ),
    );
  }

  Widget _buildMovieTab() {
    if (wishlistMovies.isEmpty) {
      return const Center(
        child: Text(
          'No movies in your wishlist',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: wishlistMovies.length,
      itemBuilder: (context, index) {
        final movie = wishlistMovies[index];
        return _buildMovieCard(movie);
      },
    );
  }

  Widget _buildTVShowTab() {
    if (wishlistTVShows.isEmpty) {
      return const Center(
        child: Text(
          'No TV shows in your wishlist',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: wishlistTVShows.length,
      itemBuilder: (context, index) {
        final tvshow = wishlistTVShows[index];
        return _buildTVShowCard(tvshow);
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(
                movie: movie,
                onFavoriteChanged: () => _loadWishlist(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.releaseDate,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTVShowCard(TVShow tvshow) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TVShowDetailScreen(
                tvshow: tvshow,
                onFavoriteChanged: () => _loadWishlist(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w200${tvshow.posterPath}',
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvshow.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tvshow.firstAirDate,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tvshow.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
