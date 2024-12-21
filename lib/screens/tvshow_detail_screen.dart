import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_realm_app_alpha_1_0/models/cast.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';
import 'package:movie_realm_app_alpha_1_0/services/api_service.dart';

class TVShowDetailScreen extends StatefulWidget {
  final TVShow tvshow;
  final VoidCallback onFavoriteChanged;

  const TVShowDetailScreen(
      {super.key, required this.tvshow, required this.onFavoriteChanged});

  @override
  _TVShowDetailScreenState createState() => _TVShowDetailScreenState();
}

class _TVShowDetailScreenState extends State<TVShowDetailScreen> {
  List<Cast> castList = [];
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchCast();
    _checkIfFavorite();
  }

  Future<void> _fetchCast() async {
    try {
      final cast = await ApiService.fetchTVShowCast(widget.tvshow.id);
      setState(() {
        castList = cast;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cast: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteTVShows = prefs.getStringList('wishlist_tvshows') ?? [];
    if (favoriteTVShows.contains(widget.tvshow.id.toString())) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteTVShows = prefs.getStringList('wishlist_tvshows') ?? [];

    if (isFavorite) {
      favoriteTVShows.remove(widget.tvshow.id.toString());
    } else {
      favoriteTVShows.add(widget.tvshow.id.toString());
    }

    await prefs.setStringList('wishlist_tvshows', favoriteTVShows);

    setState(() {
      isFavorite = !isFavorite;
    });

    widget.onFavoriteChanged();
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> genreSpans = [];
    for (int i = 0; i < widget.tvshow.genres.length; i++) {
      genreSpans.add(
        TextSpan(
          text: widget.tvshow.genres[i].name,
          style: const TextStyle(color: Colors.grey),
        ),
      );
      if (i < widget.tvshow.genres.length - 1) {
        genreSpans.add(
          const TextSpan(
            text: ' • ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${widget.tvshow.posterPath}',
                      ),
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.black.withOpacity(0.8),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.tvshow.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('|', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 8),
                        Text(
                          widget.tvshow.firstAirDate.split('-')[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(children: genreSpans),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.tvshow.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.tvshow.firstAirDate),
                  const SizedBox(height: 8),
                  Text(widget.tvshow.overview),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      isFavorite ? 'Delete From Wishlist' : 'Add To Wishlist',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : castList.isEmpty
                          ? const Text('No cast information available.')
                          : SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: castList.length,
                                itemBuilder: (context, index) {
                                  final cast = castList[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: 100,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              cast.profilePath.isNotEmpty
                                                  ? NetworkImage(
                                                      'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                                    )
                                                  : null,
                                          child: cast.profilePath.isEmpty
                                              ? const Icon(Icons.person,
                                                  size: 40)
                                              : null,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          cast.name,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          cast.character,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
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
