import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/presentation/bloc/now_playing/now_playing_tv_series_bloc.dart';
import 'package:tv_series/tv_series.dart';

class HomeTvPage extends StatefulWidget {
  const HomeTvPage({Key? key}) : super(key: key);

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvSeriesBloc>().add(
            const FetchNowPlayingTvSeries(),
          );
      context.read<PopularTvSeriesBloc>().add(
            const FetchPopularTvSeries(),
          );
      context.read<TopRatedTvSeriesBloc>().add(
            const FetchTopRatedTvSeries(),
          );
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
        title: const Text('Ditonton TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                searchRoute,
                arguments: ContentSearch.TvSeries,
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
              BlocBuilder<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
                builder: (context, state) {
                  if (state is NowPlayingTvSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingTvSeriesHasData) {
                    return _TvList(
                      keySection: 'now_playing',
                      tvSeries: state.tvSeries,
                    );
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              ContentSubHeading(
                key: const Key('popular_heading'),
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(context, popularTvSeriesRoute);
                },
              ),
              BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
                builder: (context, state) {
                  if (state is PopularTvSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvSeriesHasData) {
                    return _TvList(
                      keySection: 'popular',
                      tvSeries: state.tvSeries,
                    );
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              ContentSubHeading(
                key: const Key('top_rated_heading'),
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(context, topRatedTvSeriesRoute);
                },
              ),
              BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
                builder: (context, state) {
                  if (state is TopRatedTvSeriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTvSeriesHasData) {
                    return _TvList(
                      keySection: 'top_rated',
                      tvSeries: state.tvSeries,
                    );
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

class _TvList extends StatelessWidget {
  final String keySection;
  final List<Tv> tvSeries;

  const _TvList({
    required this.keySection,
    required this.tvSeries,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              key: Key('${keySection}_$index'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvDetailRoute,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
