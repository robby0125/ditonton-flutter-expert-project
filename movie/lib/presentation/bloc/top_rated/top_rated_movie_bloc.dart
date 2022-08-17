import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'top_rated_movie_event.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<FetchTopRatedMovies, TopRatedMovieState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMovieBloc({
    required this.getTopRatedMovies,
  }) : super(TopRatedMoviesLoading()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(TopRatedMoviesError(failure.message)),
        (movies) => emit(TopRatedMoviesHasData(movies)),
      );
    });
  }
}
