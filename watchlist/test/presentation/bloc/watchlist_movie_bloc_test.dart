import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/watchlist.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieBloc watchlistMovieBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  group('Watchlist Movie', () {
    final tWatchlistMovie = Movie.watchlist(
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      title: 'title',
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Empty] when movie watchlist is empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));

        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, HasData] when movie watchlist is not empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([tWatchlistMovie]));

        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData([tWatchlistMovie]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Error] when get movie watchlist is failed',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
