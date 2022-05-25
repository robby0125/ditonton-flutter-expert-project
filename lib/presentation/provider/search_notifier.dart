import 'package:ditonton/common/content_search_enum.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
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
      await fetchMovieSearch(query);
    } else {
      await fetchTvSearch(query);
    }
  }

  Future<void> fetchMovieSearch(String query) async {
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

  Future<void> fetchTvSearch(String query) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final _result = await searchTvSeries.execute(query);
    _result.fold(
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
