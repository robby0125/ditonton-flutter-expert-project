import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'popular_movie_event.dart';

part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<FetchPopularMovies, PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc({
    required this.getPopularMovies,
  }) : super(PopularMoviesLoading()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());

      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(PopularMoviesError(failure.message)),
        (movies) => emit(PopularMoviesHasData(movies)),
      );
    });
  }
}
