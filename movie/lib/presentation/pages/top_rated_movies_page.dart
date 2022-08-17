import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<TopRatedMovieBloc>(context).add(
        const FetchTopRatedMovies(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
            builder: (context, state) {
          if (state is TopRatedMoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TopRatedMoviesHasData) {
            return ListView.builder(
              key: const Key('top_rated_list'),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return ItemCard(
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
          } else if (state is TopRatedMoviesError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const Center(
              key: Key('error_message'),
              child: Text('Failed'),
            );
          }
        }),
      ),
    );
  }
}
