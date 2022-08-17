import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'top_rated_tv_series_event.dart';

part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<FetchTopRatedTvSeries, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc({
    required this.getTopRatedTvSeries,
  }) : super(TopRatedTvSeriesLoading()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTvSeriesLoading());

      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TopRatedTvSeriesError(failure.message)),
        (tvSeries) => emit(TopRatedTvSeriesHasData(tvSeries)),
      );
    });
  }
}
