import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_season_detail_event.dart';

part 'tv_season_detail_state.dart';

class TvSeasonDetailBloc
    extends Bloc<FetchTvSeasonDetail, TvSeasonDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvSeasonDetail getTvSeasonDetail;

  TvSeasonDetailBloc({
    required this.getTvDetail,
    required this.getTvSeasonDetail,
  }) : super(TvSeasonDetailLoading()) {
    on<FetchTvSeasonDetail>((event, emit) async {
      emit(TvSeasonDetailLoading());

      final tvDetailResult = await getTvDetail.execute(event.tvId);
      final seasonDetailResult = await getTvSeasonDetail.execute(
        event.tvId,
        event.seasonNumber,
      );
      tvDetailResult.fold(
        (failure) => emit(TvSeasonDetailError(failure.message)),
        (tvDetail) {
          seasonDetailResult.fold(
            (failure) => emit(TvSeasonDetailError(failure.message)),
            (seasonDetail) =>
                emit(TvSeasonDetailHasData(tvDetail, seasonDetail)),
          );
        },
      );
    });
  }
}
