import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/content_search_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final ContentSearch type;

  const SearchPage({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: Key('query_field'),
              onSubmitted: (query) {
                Provider.of<SearchNotifier>(context, listen: false)
                    .performSearch(type: type, query: query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<SearchNotifier>(
              builder: (context, data, child) {
                final _currentState = type == ContentSearch.Movie
                    ? data.movieState
                    : data.tvState;

                if (_currentState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_currentState == RequestState.Loaded) {
                  final result = type == ContentSearch.Movie
                      ? data.searchMovieResult
                      : data.searchTvResult;

                  return Expanded(
                    child: ListView.builder(
                      key: Key('result_list'),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        int _id = 0;
                        String? _title;
                        String? _overview;
                        String? _posterPath;

                        if (type == ContentSearch.Movie) {
                          final _movie = data.searchMovieResult[index];

                          _id = _movie.id;
                          _title = _movie.title;
                          _overview = _movie.overview;
                          _posterPath = _movie.posterPath;
                        } else {
                          final _tv = data.searchTvResult[index];

                          _id = _tv.id;
                          _title = _tv.name;
                          _overview = _tv.overview;
                          _posterPath = _tv.posterPath;
                        }

                        return ItemCard(
                          id: _id,
                          title: _title,
                          overview: _overview,
                          posterPath: _posterPath,
                          onTap: () {
                            final _targetRouteName = type == ContentSearch.Movie
                                ? MovieDetailPage.ROUTE_NAME
                                : TvDetailPage.ROUTE_NAME;

                            Navigator.pushNamed(
                              context,
                              _targetRouteName,
                              arguments: _id,
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
