import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'now_playing_tv_series_event.dart';

part 'now_playing_tv_series_state.dart';

class NowPlayingTvSeriesBloc
    extends Bloc<FetchNowPlayingTvSeries, NowPlayingTvSeriesState> {
  final GetOnAirTvSeries getOnAirTvSeries;

  NowPlayingTvSeriesBloc({
    required this.getOnAirTvSeries,
  }) : super(NowPlayingTvSeriesLoading()) {
    on<FetchNowPlayingTvSeries>((event, emit) async {
      emit(NowPlayingTvSeriesLoading());

      final result = await getOnAirTvSeries.execute();
      result.fold(
        (failure) => emit(NowPlayingTvSeriesError(failure.message)),
        (tvSeries) => emit(NowPlayingTvSeriesHasData(tvSeries)),
      );
    });
  }
}
