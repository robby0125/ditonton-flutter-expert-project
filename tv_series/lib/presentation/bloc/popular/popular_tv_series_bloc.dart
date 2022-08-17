import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'popular_tv_series_event.dart';

part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<FetchPopularTvSeries, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({
    required this.getPopularTvSeries,
  }) : super(PopularTvSeriesLoading()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(PopularTvSeriesLoading());

      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(PopularTvSeriesError(failure.message)),
        (tvSeries) => emit(PopularTvSeriesHasData(tvSeries)),
      );
    });
  }
}
