import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<FetchMovieDetail, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailLoading()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);
      detailResult.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) {
          recommendationResult.fold(
            (failure) => emit(MovieDetailError(failure.message)),
            (recommendations) => emit(MovieDetailHasData(
              movie: movie,
              recommendations: recommendations,
            )),
          );
        },
      );
    });
  }
}
