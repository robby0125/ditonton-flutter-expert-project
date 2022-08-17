import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_detail_event.dart';

part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<FetchTvSeriesDetail, TvSeriesDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendation;

  TvSeriesDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendation,
  }) : super(TvSeriesDetailLoading()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendation.execute(event.id);
      detailResult.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (movie) {
          recommendationResult.fold(
            (failure) => emit(TvSeriesDetailError(failure.message)),
            (recommendations) => emit(TvSeriesDetailHasData(
              tv: movie,
              recommendations: recommendations,
            )),
          );
        },
      );
    });
  }
}
