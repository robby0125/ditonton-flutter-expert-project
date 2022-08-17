import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class PopularTvSeriesPage extends StatefulWidget {
  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularTvSeriesBloc>().add(
            const FetchPopularTvSeries(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
          builder: (context, state) {
            if (state is PopularTvSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvSeriesHasData) {
              return ListView.builder(
                key: const Key('popular_list'),
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
            } else if (state is PopularTvSeriesError) {
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
