part of 'tv_series_watchlist_bloc.dart';

class TvSeriesWatchlistState extends Equatable {
  final String message;
  final bool isAddedToWatchlist;

  const TvSeriesWatchlistState({
    this.message = '',
    this.isAddedToWatchlist = false,
  });

  @override
  List<Object?> get props => [message, isAddedToWatchlist];
}
