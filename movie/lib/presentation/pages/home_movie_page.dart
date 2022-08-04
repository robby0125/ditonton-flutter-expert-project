import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/widgets/content_sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
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
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return _MovieList(
                    keySection: 'now_playing',
                    movies: data.nowPlayingMovies,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              ContentSubHeading(
                key: const Key('popular_heading'),
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, popularMoviesRoute);
                },
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return _MovieList(
                    keySection: 'popular',
                    movies: data.popularMovies,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
              ContentSubHeading(
                key: const Key('top_rated_heading'),
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, topRatedMovieRoute);
                },
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return _MovieList(
                    keySection: 'top_rated',
                    movies: data.topRatedMovies,
                  );
                } else {
                  return const Text('Failed');
                }
              }),
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
