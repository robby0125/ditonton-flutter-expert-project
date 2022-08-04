import 'package:core/core.dart';
import 'package:core/presentation/widgets/item_card.dart';
import 'package:flutter/material.dart';
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
    Future.microtask(() =>
        Provider.of<TopRatedTvSeriesNotifier>(context, listen: false)
            .fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                key: const Key('top_rated_list'),
                itemBuilder: (context, index) {
                  final tv = data.tvSeries[index];
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
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
