import 'package:flutter/material.dart';
import 'package:movie_realm_app_alpha_1_0/models/tvshow.dart';
import 'services/api_service.dart';
import 'models/movie.dart';
import 'models/genre.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/tvshow_detail_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/search_screen.dart';

List<Genre> moviesGenres = [];
List<Genre> tvshowsGenres = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  moviesGenres = await ApiService.fetchGenresMovies();
  tvshowsGenres = await ApiService.fetchGenresTVShows();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieRealm',
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => BottomNavBarScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/movieDetail') {
          final movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movie: movie,
              onFavoriteChanged: () {},
            ),
          );
        }
        if (settings.name == '/tvshowDetail') {
          final tvshow = settings.arguments as TVShow;
          return MaterialPageRoute(
            builder: (context) => TVShowDetailScreen(
              tvshow: tvshow,
              onFavoriteChanged: () {},
            ),
          );
        }
        return null;
      },
    );
  }
}

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    SearchScreen(),
    WishlistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              backgroundColor: Colors.white,
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(
                () {
                  _selectedIndex = index;
                },
              );
            },
            indicatorColor: Colors.blue,
            selectedIndex: _selectedIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                icon: Icon(Icons.search_outlined),
                label: 'Search',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                icon: Icon(Icons.favorite_outline),
                label: 'Wishlist',
              ),
            ],
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          ),
        ));
  }
}
