import 'package:core/core.dart';
import 'package:core/presentation/provider/search_notifier.dart';
import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  final ContentSearch type;

  const SearchPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const Key('query_field'),
              onSubmitted: (query) {
                Provider.of<SearchNotifier>(context, listen: false)
                    .performSearch(type: type, query: query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                final currentState = type == ContentSearch.Movie
                    ? data.movieState
                    : data.tvState;

                if (currentState == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (currentState == RequestState.Loaded) {
                  final result = type == ContentSearch.Movie
                      ? data.searchMovieResult
                      : data.searchTvResult;

                  return Expanded(
                    child: ListView.builder(
                      key: const Key('result_list'),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        int id = 0;
                        String? title;
                        String? overview;
                        String? posterPath;

                        if (type == ContentSearch.Movie) {
                          final movie = data.searchMovieResult[index];

                          id = movie.id;
                          title = movie.title;
                          overview = movie.overview;
                          posterPath = movie.posterPath;
                        } else {
                          final tv = data.searchTvResult[index];

                          id = tv.id;
                          title = tv.name;
                          overview = tv.overview;
                          posterPath = tv.posterPath;
                        }

                        return ItemCard(
                          id: id,
                          title: title,
                          overview: overview,
                          posterPath: posterPath,
                          onTap: () {
                            final targetRouteName = type == ContentSearch.Movie
                                ? movieDetailRoute
                                : tvDetailRoute;

                            Navigator.pushNamed(
                              context,
                              targetRouteName,
                              arguments: id,
                            );
                          },
                        );
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
