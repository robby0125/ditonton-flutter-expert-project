part of 'tv_series_watchlist_bloc.dart';

abstract class TvSeriesWatchlistEvent extends Equatable {
  const TvSeriesWatchlistEvent();
}

class AddWatchlist extends TvSeriesWatchlistEvent {
  final TvDetail tv;

  const AddWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class RemoveWatchlist extends TvSeriesWatchlistEvent {
  final TvDetail tv;

  const RemoveWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class LoadWatchlistStatus extends TvSeriesWatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}