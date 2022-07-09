import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/search_tv_series.dart';
import 'package:core/utils/content_search_enum.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTvSeries searchTvSeries;

  SearchNotifier({
    required this.searchMovies,
    required this.searchTvSeries,
  });

  RequestState _movieState = RequestState.Empty;

  RequestState get movieState => _movieState;

  List<Movie> _searchMovieResult = [];

  List<Movie> get searchMovieResult => _searchMovieResult;

  RequestState _tvState = RequestState.Empty;

  RequestState get tvState => _tvState;

  List<Tv> _searchTvResult = [];

  List<Tv> get searchTvResult => _searchTvResult;

  String _message = '';

  String get message => _message;

  Future<void> performSearch({
    required ContentSearch type,
    required String query,
  }) async {
    if (type == ContentSearch.Movie) {
      await _fetchMovieSearch(query);
    } else {
      await _fetchTvSearch(query);
    }
  }

  Future<void> _fetchMovieSearch(String query) async {
    _movieState = RequestState.Loading;
    notifyListeners();

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _movieState = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchMovieResult = data;
        _movieState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> _fetchTvSearch(String query) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _tvState = RequestState.Loaded;
        _searchTvResult = data;
        notifyListeners();
      },
    );
  }
}
