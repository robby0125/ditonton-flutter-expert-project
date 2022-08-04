import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:tv_series/tv_series.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendation;
  final GetTvWatchlistStatus getTvWatchlistStatus;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendation,
    required this.getTvWatchlistStatus,
    required this.saveTvWatchlist,
    required this.removeTvWatchlist,
  });

  late TvDetail _tv;

  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;

  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendation = [];

  List<Tv> get tvRecommendation => _tvRecommendation;

  RequestState _recommendationState = RequestState.Empty;

  RequestState get recommendationState => _recommendationState;

  String _message = '';

  String get message => _message;

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  bool _isAddedToWatchlist = false;

  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendation.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.Loading;
        _tv = tv;

        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvSeries) {
            _recommendationState = RequestState.Loaded;
            _tvRecommendation = tvSeries;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveTvWatchlist.execute(tv);

    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeTvWatchlist.execute(tv);

    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getTvWatchlistStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
