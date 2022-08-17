import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingMovieBloc>(context)
          .add(const FetchNowPlayingMovies());
      BlocProvider.of<PopularMovieBloc>(context)
          .add(const FetchPopularMovies());
      BlocProvider.of<TopRatedMovieBloc>(context)
          .add(const FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('drawer_button'),
          onPressed: () {
            BlocProvider.of<ZoomDrawerBloc>(context).controller.toggle?.call();
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Ditonton Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                searchRoute,
                arguments: ContentSearch.Movie,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                builder: (context, state) {
                  if (state is NowPlayingMovieLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingMovieHasData) {
                    return _MovieList(
                      keySection: 'now_playing',
                      movies: state.movies,
                    );
                  } else if (state is NowPlayingMovieError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              ContentSubHeading(
                key: const Key('popular_heading'),
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, popularMoviesRoute);
                },
              ),
              BlocBuilder<PopularMovieBloc, PopularMovieState>(
                builder: (context, state) {
                  if (state is PopularMoviesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularMoviesHasData) {
                    return _MovieList(
                      keySection: 'popular',
                      movies: state.movies,
                    );
                  } else if (state is PopularMoviesError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              ContentSubHeading(
                key: const Key('top_rated_heading'),
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, topRatedMovieRoute);
                },
              ),
              BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedMoviesHasData) {
                    return _MovieList(
                      keySection: 'top_rated',
                      movies: state.movies,
                    );
                  } else if (state is TopRatedMoviesError) {
                    return Text(state.message);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieList extends StatelessWidget {
  final String keySection;
  final List<Movie> movies;

  const _MovieList({
    required this.keySection,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key('${keySection}_$index'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  movieDetailRoute,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
