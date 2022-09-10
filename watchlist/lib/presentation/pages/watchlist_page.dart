import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist.dart';

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
      context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovie());
      context.read<WatchlistTvSeriesBloc>().add(const FetchWatchlistTvSeries());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovie());
    context.read<WatchlistTvSeriesBloc>().add(const FetchWatchlistTvSeries());
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
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieHasData) {
            return ListView.builder(
              key: const Key('movie_watchlist_listview'),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
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
              itemCount: state.movies.length,
            );
          } else if (state is WatchlistMovieError) {
            return _buildErrorMessage(
              message: state.message,
              alternateMessage: 'Empty Movie Watchlist',
            );
          } else {
            return _buildErrorMessage(
              message: 'Empty Movie Watchlist',
            );
          }
        },
      ),
    );
  }

  Widget _buildTvWatchlistPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        builder: (context, state) {
          if (state is WatchlistTvSeriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistTvSeriesHasData) {
            return ListView.builder(
              key: const Key('tv_watchlist_listview'),
              itemBuilder: (context, index) {
                final tv = state.tvSeries[index];
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
              itemCount: state.tvSeries.length,
            );
          } else if (state is WatchlistTvSeriesError) {
            return _buildErrorMessage(
              message: state.message,
              alternateMessage: 'Empty TV Watchlist',
            );
          } else {
            return _buildErrorMessage(
              message: 'Empty TV Watchlist',
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorMessage({
    required String message,
    String alternateMessage = 'No Message',
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
