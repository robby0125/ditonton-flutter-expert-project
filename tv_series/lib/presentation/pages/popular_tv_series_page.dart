import 'package:core/core.dart';
import 'package:core/presentation/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Future.microtask(() =>
        Provider.of<PopularTvSeriesNotifier>(context, listen: false)
            .fetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                key: const Key('popular_list'),
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
