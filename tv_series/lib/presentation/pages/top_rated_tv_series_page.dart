import 'package:core/core.dart';
import 'package:core/presentation/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_series/tv_series.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTvSeriesPage> createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedTvSeriesBloc>().add(
            const FetchTopRatedTvSeries(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvSeriesHasData) {
              return ListView.builder(
                key: const Key('top_rated_list'),
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return ItemCard(
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
            } else if (state is TopRatedTvSeriesError) {
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
          },
        ),
      ),
    );
  }
}
