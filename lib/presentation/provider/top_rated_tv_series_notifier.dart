import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TopRatedTvSeriesNotifier extends ChangeNotifier {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesNotifier({required this.getTopRatedTvSeries});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _tvSeries = [];

  List<Tv> get tvSeries => _tvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchTopRatedTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final _result = await getTopRatedTvSeries.execute();
    _result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeries = tvSeriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
