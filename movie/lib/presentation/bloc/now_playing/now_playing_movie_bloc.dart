import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'now_playing_movie_event.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<FetchNowPlayingMovies, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMovieLoading()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMovieLoading());

      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(NowPlayingMovieError(failure.message)),
        (movies) => emit(NowPlayingMovieHasData(movies)),
      );
    });
  }
}
