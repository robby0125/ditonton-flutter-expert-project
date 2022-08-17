part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;

  const NowPlayingMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingMovieHasData extends NowPlayingMovieState {
  final List<Movie> movies;

  const NowPlayingMovieHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
