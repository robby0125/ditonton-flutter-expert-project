import 'package:core/utils/state_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:tv_series/tv_series.dart';

class TvListNotifier extends ChangeNotifier {
  final GetOnAirTvSeries getOnAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvListNotifier({
    required this.getOnAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  });

  var _onAirTvSeries = <Tv>[];

  List<Tv> get onAirTvSeries => _onAirTvSeries;

  RequestState _onAirState = RequestState.Empty;

  RequestState get onAirState => _onAirState;

  var _popularTvSeries = <Tv>[];

  List<Tv> get popularTvSeries => _popularTvSeries;

  RequestState _popularState = RequestState.Empty;

  RequestState get popularState => _popularState;

  var _topRatedTvSeries = <Tv>[];

  List<Tv> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _topRatedState = RequestState.Empty;

  RequestState get topRatedState => _topRatedState;

  String _message = '';

  String get message => _message;

  Future<void> fetchOnAirTvSeries() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvSeries.execute();
    result.fold(
      (failure) {
        _onAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _onAirState = RequestState.Loaded;
        _onAirTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _popularState = RequestState.Loaded;
        _popularTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _topRatedState = RequestState.Loaded;
        _topRatedTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
