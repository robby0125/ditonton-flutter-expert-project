import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
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
          title: Text('Watchlist'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return ItemCard(
                  id: movie.id,
                  title: movie.title,
                  overview: movie.overview,
                  posterPath: movie.posterPath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MovieDetailPage.ROUTE_NAME,
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = data.watchlistTvSeries[index];
                return ItemCard(
                  id: tv.id,
                  title: tv.name,
                  overview: tv.overview,
                  posterPath: tv.posterPath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TvDetailPage.ROUTE_NAME,
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
              alternateMessage: 'Empty Tv Watchlist',
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
      key: Key('error_message'),
      child: Text(message.isNotEmpty ? message : alternateMessage),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
