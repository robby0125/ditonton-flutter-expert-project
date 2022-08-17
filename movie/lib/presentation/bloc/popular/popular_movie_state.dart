part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMoviesLoading extends PopularMovieState {}

class PopularMoviesError extends PopularMovieState {
  final String message;

  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMoviesHasData extends PopularMovieState {
  final List<Movie> movies;

  const PopularMoviesHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
