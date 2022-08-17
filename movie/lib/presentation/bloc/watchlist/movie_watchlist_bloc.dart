import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_watchlist_event.dart';

part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final SaveMovieWatchlist saveMovieWatchlist;
  final RemoveMovieWatchlist removeMovieWatchlist;
  final GetMovieWatchListStatus getMovieWatchListStatus;

  String _message = '';

  MovieWatchlistBloc({
    required this.saveMovieWatchlist,
    required this.removeMovieWatchlist,
    required this.getMovieWatchListStatus,
  }) : super(const MovieWatchlistState()) {
    on<AddWatchlist>(_addWatchlist);
    on<RemoveWatchlist>(_removeWatchlist);
    on<LoadWatchlistStatus>(_loadWatchlistStatus);
  }

  Future<void> _addWatchlist(AddWatchlist event, Emitter emit) async {
    final result = await saveMovieWatchlist.execute(event.movie);
    result.fold(
      (failure) => _message = failure.message,
      (successMessage) => _message = successMessage,
    );

    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _removeWatchlist(RemoveWatchlist event, Emitter emit) async {
    final result = await removeMovieWatchlist.execute(event.movie);
    result.fold(
      (failure) => _message = failure.message,
      (successMessage) => _message = successMessage,
    );

    add(LoadWatchlistStatus(event.movie.id));
  }

  Future<void> _loadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter emit,
  ) async {
    final result = await getMovieWatchListStatus.execute(event.id);
    emit(MovieWatchlistState(message: _message, isAddedToWatchlist: result));
  }
}
