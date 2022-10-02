import 'package:core/utils/content_search_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv_series.dart';
import 'package:tv_series/tv_series.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final SearchTvSeries searchTvSeries;

  SearchBloc({
    required this.searchMovies,
    required this.searchTvSeries,
  }) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;
        final isMovieSearch = event.contentSearch == ContentSearch.Movie;

        emit(SearchLoading());

        final result = isMovieSearch
            ? await searchMovies.execute(query)
            : await searchTvSeries.execute(query);
        result.fold(
          (failure) {
            emit(SearchError(failure.message));
          },
          (data) {
            if (isMovieSearch) {
              emit(SearchHasData<Movie>(data as List<Movie>));
            } else {
              emit(SearchHasData<Tv>(data as List<Tv>));
            }
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<ClearState>((event, emit) {
      emit(SearchEmpty());
    });
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
