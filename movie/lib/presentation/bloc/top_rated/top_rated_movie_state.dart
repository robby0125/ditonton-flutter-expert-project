part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesLoading extends TopRatedMovieState {}

class TopRatedMoviesError extends TopRatedMovieState {
  final String message;

  const TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMoviesHasData extends TopRatedMovieState {
  final List<Movie> movies;

  const TopRatedMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
