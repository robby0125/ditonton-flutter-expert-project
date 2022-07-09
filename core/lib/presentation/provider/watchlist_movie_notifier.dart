import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieNotifier({required this.getWatchlistMovies});

  var _watchlistMovies = <Movie>[];

  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  String _message = '';

  String get message => _message;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        if (moviesData.isNotEmpty) {
          _watchlistState = RequestState.Loaded;
          _watchlistMovies = moviesData;
        } else {
          _watchlistState = RequestState.Empty;
        }

        notifyListeners();
      },
    );
  }
}
