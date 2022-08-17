import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

part 'tv_series_watchlist_event.dart';

part 'tv_series_watchlist_state.dart';

class TvSeriesWatchlistBloc
    extends Bloc<TvSeriesWatchlistEvent, TvSeriesWatchlistState> {
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;
  final GetTvWatchlistStatus getTvWatchlistStatus;

  String _message = '';

  TvSeriesWatchlistBloc({
    required this.saveTvWatchlist,
    required this.removeTvWatchlist,
    required this.getTvWatchlistStatus,
  }) : super(const TvSeriesWatchlistState()) {
    on<AddWatchlist>(_addWatchlist);
    on<RemoveWatchlist>(_removeWatchlist);
    on<LoadWatchlistStatus>(_loadWatchlistStatus);
  }

  Future<void> _addWatchlist(AddWatchlist event, Emitter emit) async {
    final result = await saveTvWatchlist.execute(event.tv);
    result.fold(
      (failure) => _message = failure.message,
      (successMessage) => _message = successMessage,
    );

    add(LoadWatchlistStatus(event.tv.id));
  }

  Future<void> _removeWatchlist(RemoveWatchlist event, Emitter emit) async {
    final result = await removeTvWatchlist.execute(event.tv);
    result.fold(
      (failure) => _message = failure.message,
      (successMessage) => _message = successMessage,
    );

    add(LoadWatchlistStatus(event.tv.id));
  }

  Future<void> _loadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter emit,
  ) async {
    final result = await getTvWatchlistStatus.execute(event.id);
    emit(TvSeriesWatchlistState(message: _message, isAddedToWatchlist: result));
  }
}
