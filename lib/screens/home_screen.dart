import 'package:flutter/material.dart';
import 'package:movie_realm_app_alpha_1_0/main.dart';
import 'package:movie_realm_app_alpha_1_0/services/api_service.dart';
import 'package:movie_realm_app_alpha_1_0/models/movie.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';
import 'package:movie_realm_app_alpha_1_0/widgets/movie_card.dart';
import 'package:movie_realm_app_alpha_1_0/widgets/tvshow_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> trendingAll = [];
  List<Movie> popularMovies = [];
  List<TVShow> popularTVShows = [];
  List<Movie> topratedMovies = [];
  List<TVShow> topratedTVShows = [];
  List<Movie> upcomingMovies = [];
  List<TVShow> ontheairTVShows = [];
  String selectedTimeWindow = 'day';
  String selectedPopularCategory = 'Movies';
  String selectedTopRatedCategory = 'Movies';

  @override
  void initState() {
    super.initState();
    _fetchTrendingAll();
    _fetchPopularMovies();
    _fetchPopularTVShows();
    _fetchTopRatedMovies();
    _fetchTopRatedTVShows();
    _fetchUpcomingMovies();
    _fetchOnTheAirTVShows();
  }

  void _fetchTrendingAll() async {
    try {
      final movieGenres = await ApiService.fetchGenresMovies();
      final tvGenres = await ApiService.fetchGenresTVShows();

      final results = await ApiService.fetchTrendingAll(
          selectedTimeWindow, movieGenres, tvGenres);

      setState(() {
        trendingAll = results;
      });
    } catch (e) {
      print('Error fetching trending: $e');
    }
  }

  void _fetchPopularMovies() async {
    try {
      final results = await ApiService.fetchPopularMovies(moviesGenres);
      setState(() {
        popularMovies = results;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  void _fetchPopularTVShows() async {
    try {
      final results = await ApiService.fetchPopularTVShows(tvshowsGenres);
      setState(() {
        popularTVShows = results;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  void _fetchTopRatedMovies() async {
    try {
      final results = await ApiService.fetchTopRatedMovies(moviesGenres);
      setState(() {
        topratedMovies = results;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  void _fetchTopRatedTVShows() async {
    try {
      final results = await ApiService.fetchTopRatedTVShow(tvshowsGenres);
      setState(() {
        topratedTVShows = results;
      });
    } catch (e) {
      print('Error fetching TV shows: $e');
    }
  }

  void _fetchUpcomingMovies() async {
    try {
      final results = await ApiService.fetchUpcomingMovies(moviesGenres);
      setState(() {
        upcomingMovies = results;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  void _fetchOnTheAirTVShows() async {
    try {
      final results = await ApiService.fetchOnTheAirTVShow(tvshowsGenres);
      setState(() {
        ontheairTVShows = results;
      });
    } catch (e) {
      print('Error fetching TV shows: $e');
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
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Text(
              'ovieRealm',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: DropdownButton<String>(
                      value: selectedTimeWindow,
                      items: ['day', 'week'].map((String window) {
                        return DropdownMenuItem<String>(
                          value: window,
                          child: Text(
                            window == 'day' ? 'Today' : 'This Week',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedTimeWindow = value!;
                          _fetchTrendingAll(); // Refresh data
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.blue,
                      iconEnabledColor: Colors.white,
                      iconSize: 32,
                      isDense: true,
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
            trendingAll.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingAll.length,
                      itemBuilder: (context, index) {
                        final item = trendingAll[index];

                        if (item is Movie) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/movieDetail',
                                arguments: item,
                              );
                            },
                            child: MovieCard(movie: item),
                          );
                        } else if (item is TVShow) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/tvshowDetail',
                                arguments: item,
                              );
                            },
                            child: TVShowCard(tvshow: item),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: DropdownButton<String>(
                      value: selectedPopularCategory,
                      items: ['Movies', 'TV Shows'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPopularCategory = value!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.blue,
                      iconEnabledColor: Colors.white,
                      iconSize: 32,
                      isDense: true,
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
            selectedPopularCategory == 'Movies'
                ? popularMovies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 260,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularMovies.length,
                            itemBuilder: (context, index) {
                              final movie = popularMovies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/movieDetail',
                                    arguments: movie,
                                  );
                                },
                                child: MovieCard(movie: movie),
                              );
                            },
                          ),
                        ))
                : popularTVShows.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularTVShows.length,
                          itemBuilder: (context, index) {
                            final tvshow = popularTVShows[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/tvshowDetail',
                                  arguments: tvshow,
                                );
                              },
                              child: TVShowCard(tvshow: tvshow),
                            );
                          },
                        ),
                      ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Rated',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: DropdownButton<String>(
                      value: selectedTopRatedCategory,
                      items: ['Movies', 'TV Shows'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedTopRatedCategory = value!;
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.blue,
                      iconEnabledColor: Colors.white,
                      iconSize: 32,
                      isDense: true,
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
            selectedTopRatedCategory == 'Movies'
                ? topratedMovies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 260,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topratedMovies.length,
                            itemBuilder: (context, index) {
                              final movie = topratedMovies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/movieDetail',
                                    arguments: movie,
                                  );
                                },
                                child: MovieCard(movie: movie),
                              );
                            },
                          ),
                        ))
                : topratedTVShows.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topratedTVShows.length,
                          itemBuilder: (context, index) {
                            final tvshow = topratedTVShows[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/tvshowDetail',
                                  arguments: tvshow,
                                );
                              },
                              child: TVShowCard(tvshow: tvshow),
                            );
                          },
                        ),
                      ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Movie',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            upcomingMovies.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 260,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: upcomingMovies.length,
                        itemBuilder: (context, index) {
                          final movie = upcomingMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/movieDetail',
                                arguments: movie,
                              );
                            },
                            child: MovieCard(movie: movie),
                          );
                        },
                      ),
                    )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'On The Air TV',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ontheairTVShows.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 260,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ontheairTVShows.length,
                        itemBuilder: (context, index) {
                          final tvshow = ontheairTVShows[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/tvshowDetail', // Rute yang sudah didefinisikan
                                arguments:
                                    tvshow, // Kirim data film ke layar detail
                              );
                            },
                            child: TVShowCard(tvshow: tvshow),
                          );
                        },
                      ),
                    )),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
