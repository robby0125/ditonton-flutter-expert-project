import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

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
              onChanged: (query) {
                context.read<SearchBloc>().add(
                      OnQueryChanged(
                        query: query,
                        contentSearch: type,
                      ),
                    );
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
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchHasData) {
                  final result = state.result;

                  return Expanded(
                    child: ListView.builder(
                      key: const Key('result_list'),
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final data = result[index];

                        if (type == ContentSearch.Movie) {
                          data as Movie;
                        } else {
                          data as Tv;
                        }

                        int id = data.id;
                        String? title = data is Movie ? data.title : data.name;
                        String? overview = data.overview;
                        String? posterPath = data.posterPath;

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
                } else if (state is SearchError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
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
