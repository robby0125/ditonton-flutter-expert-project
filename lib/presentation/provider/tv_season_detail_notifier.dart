import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter/material.dart';

class TvSeasonDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvSeasonDetail getTvSeasonDetail;

  TvSeasonDetailNotifier({
    required this.getTvDetail,
    required this.getTvSeasonDetail,
  });

  late TvDetail _tvDetail;
  TvDetail get tvDetail => _tvDetail;

  late TvSeasonDetail _tvSeasonDetail;
  TvSeasonDetail get tvSeasonDetail => _tvSeasonDetail;

  RequestState _requestState = RequestState.Empty;
  RequestState get requestState => _requestState;

  String _message = '';
  String get message => _message;

  int _curEpisodeExpanded = -1;
  int get curEpisodeExpanded => _curEpisodeExpanded;

  Future<void> fetchTvSeasonDetail(int tvId, int seasonNumber) async {
    _requestState = RequestState.Loading;
    notifyListeners();

    final _tvDetailResult = await getTvDetail.execute(tvId);
    final _seasonDetailResult = await getTvSeasonDetail.execute(
      tvId,
      seasonNumber,
    );
    _tvDetailResult.fold(
      (failure) {
        _requestState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvDetail) {
        _tvDetail = tvDetail;
        _seasonDetailResult.fold(
          (failure) {
            _requestState = RequestState.Error;
            _message = failure.message;
            notifyListeners();
          },
          (seasonDetail) {
            _requestState = RequestState.Loaded;
            _tvSeasonDetail = seasonDetail;
            notifyListeners();
          },
        );
      },
    );
  }

  void expandEpisodePanel(int index) {
    _curEpisodeExpanded = index;
    notifyListeners();
  }
}
