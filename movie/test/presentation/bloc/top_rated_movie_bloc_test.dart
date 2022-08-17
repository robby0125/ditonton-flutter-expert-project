import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMovieBloc topRatedMovieBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  test('initial state should be loading', () {
    expect(topRatedMovieBloc.state, TopRatedMoviesLoading());
  });

  group('Top Rated Movies', () {
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

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'should emit [Loading, HasData] when data gotten is successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        TopRatedMoviesHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        const TopRatedMoviesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
