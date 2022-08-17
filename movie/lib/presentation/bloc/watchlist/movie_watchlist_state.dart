part of 'movie_watchlist_bloc.dart';

class MovieWatchlistState extends Equatable {
  final String message;
  final bool isAddedToWatchlist;

  const MovieWatchlistState({
    this.message = '',
    this.isAddedToWatchlist = false,
  });

  @override
  List<Object?> get props => [message, isAddedToWatchlist];
}
