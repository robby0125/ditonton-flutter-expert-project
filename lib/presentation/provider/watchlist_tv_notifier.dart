import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter/material.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvNotifier({required this.getWatchlistTvSeries});

  var _watchlistTvSeries = <Tv>[];

  List<Tv> get watchlistTvSeries => _watchlistTvSeries;

  RequestState _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  String _message = '';

  String get message => _message;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final _result = await getWatchlistTvSeries.execute();
    _result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        if (tvSeriesData.isNotEmpty) {
          _watchlistState = RequestState.Loaded;
          _watchlistTvSeries = tvSeriesData;
        } else {
          _watchlistState = RequestState.Empty;
        }

        notifyListeners();
      },
    );
  }
}
