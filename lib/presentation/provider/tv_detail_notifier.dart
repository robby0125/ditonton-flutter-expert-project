import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendation;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendation,
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

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final _detailResult = await getTvDetail.execute(id);
    final _recommendationResult = await getTvRecommendation.execute(id);
    _detailResult.fold(
      (failure) {
        _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.Loading;
        _tv = tv;
        notifyListeners();
        _recommendationResult.fold(
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
}
