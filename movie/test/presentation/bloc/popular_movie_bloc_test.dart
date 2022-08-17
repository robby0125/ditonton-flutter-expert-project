import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

  test('initial state should be loading', () {
    expect(popularMovieBloc.state, PopularMoviesLoading());
  });

  group('Popular Movies', () {
    final tMovie = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: const [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    final tMovieList = <Movie>[tMovie];

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit [Loading, HasData] when data gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        const PopularMoviesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
