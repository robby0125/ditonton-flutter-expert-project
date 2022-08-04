import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:tv_series/tv_series.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();

      Provider.of<WatchlistTvNotifier>(context, listen: false)
          .fetchWatchlistTvSeries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();

    Provider.of<WatchlistTvNotifier>(context, listen: false)
        .fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(
                key: Key('movie_tab'),
                text: 'Movies',
              ),
              Tab(
                key: Key('tv_tab'),
                text: 'TV Series',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMovieWatchlistPage(),
            _buildTvWatchlistPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieWatchlistPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              key: const Key('movie_watchlist_listview'),
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return ItemCard(
                  key: Key('movie_$index'),
                  id: movie.id,
                  title: movie.title,
                  overview: movie.overview,
                  posterPath: movie.posterPath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      movieDetailRoute,
                      arguments: movie.id,
                    );
                  },
                );
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return _buildErrorMessage(
              message: data.message,
              alternateMessage: 'Empty Movie Watchlist',
            );
          }
        },
      ),
    );
  }

  Widget _buildTvWatchlistPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTvNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              key: const Key('tv_watchlist_listview'),
              itemBuilder: (context, index) {
                final tv = data.watchlistTvSeries[index];
                return ItemCard(
                  key: Key('tv_$index'),
                  id: tv.id,
                  title: tv.name,
                  overview: tv.overview,
                  posterPath: tv.posterPath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      tvDetailRoute,
                      arguments: tv.id,
                    );
                  },
                );
              },
              itemCount: data.watchlistTvSeries.length,
            );
          } else {
            return _buildErrorMessage(
              message: data.message,
              alternateMessage: 'Empty TV Watchlist',
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorMessage({
    required String message,
    required String alternateMessage,
  }) {
    return Center(
      key: const Key('error_message'),
      child: Text(message.isNotEmpty ? message : alternateMessage),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
