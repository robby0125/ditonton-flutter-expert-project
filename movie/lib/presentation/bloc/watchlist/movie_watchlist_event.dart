part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();
}

class AddWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  const AddWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  const RemoveWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class LoadWatchlistStatus extends MovieWatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}
