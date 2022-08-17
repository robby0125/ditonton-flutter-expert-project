import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMovieBloc nowPlayingMovieBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieBloc = NowPlayingMovieBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  test('initial state should be loading', () {
    expect(nowPlayingMovieBloc.state, NowPlayingMovieLoading());
  });

  group('Now Playing Movies', () {
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

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit [Loading, HasData] when data gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));

        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMovieLoading(),
        const NowPlayingMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });
}
