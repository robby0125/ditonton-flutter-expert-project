import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'watchlist_tv_series_event.dart';

part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<FetchWatchlistTvSeries, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({
    required this.getWatchlistTvSeries,
  }) : super(WatchlistTvSeriesEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (movies) {
          if (movies.isNotEmpty) {
            emit(WatchlistTvSeriesHasData(movies));
          } else {
            emit(WatchlistTvSeriesEmpty());
          }
        },
      );
    });
  }
}
