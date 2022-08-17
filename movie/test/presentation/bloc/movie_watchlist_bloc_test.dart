import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
  GetMovieWatchListStatus,
])
void main() {
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;
  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
    movieWatchlistBloc = MovieWatchlistBloc(
      saveMovieWatchlist: mockSaveMovieWatchlist,
      removeMovieWatchlist: mockRemoveMovieWatchlist,
      getMovieWatchListStatus: mockGetMovieWatchListStatus,
    );
  });

  test('initial state should be empty message and not added to watchlist', () {
    expect(movieWatchlistBloc.state, const MovieWatchlistState());
    expect(movieWatchlistBloc.state.message, '');
    expect(movieWatchlistBloc.state.isAddedToWatchlist, false);
  });

  group('Watchlist Movie', () {
    group('Add Watchlist', () {
      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'should emit MovieWatchlistState with success message when add watchlist is successfully',
        build: () {
          when(mockSaveMovieWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => true);
          return movieWatchlistBloc;
        },
        act: (bloc) => bloc.add(const AddWatchlist(testMovieDetail)),
        expect: () => [
          const MovieWatchlistState(
            message: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ],
        verify: (bloc) {
          verify(mockSaveMovieWatchlist.execute(testMovieDetail));
          verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
        },
      );

      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'should emit MovieWatchlistState with error message when add watchlist is successfully',
        build: () {
          when(mockSaveMovieWatchlist.execute(testMovieDetail)).thenAnswer(
              (_) async => Left(DatabaseFailure('Database Failure')));
          when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return movieWatchlistBloc;
        },
        act: (bloc) => bloc.add(const AddWatchlist(testMovieDetail)),
        expect: () => [
          const MovieWatchlistState(
            message: 'Database Failure',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockSaveMovieWatchlist.execute(testMovieDetail));
          verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
        },
      );
    });

    group('Remove Watchlist', () {
      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'should emit MovieWatchlistState with success message when remove watchlist is successfully',
        build: () {
          when(mockRemoveMovieWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return movieWatchlistBloc;
        },
        act: (bloc) => bloc.add(const RemoveWatchlist(testMovieDetail)),
        expect: () => [
          const MovieWatchlistState(
            message: 'Removed from Watchlist',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveMovieWatchlist.execute(testMovieDetail));
          verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
        },
      );

      blocTest<MovieWatchlistBloc, MovieWatchlistState>(
        'should emit MovieWatchlistState with error message when remove watchlist is successfully',
        build: () {
          when(mockRemoveMovieWatchlist.execute(testMovieDetail)).thenAnswer(
              (_) async => Left(DatabaseFailure('Database Failure')));
          when(mockGetMovieWatchListStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return movieWatchlistBloc;
        },
        act: (bloc) => bloc.add(const RemoveWatchlist(testMovieDetail)),
        expect: () => [
          const MovieWatchlistState(
            message: 'Database Failure',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveMovieWatchlist.execute(testMovieDetail));
          verify(mockGetMovieWatchListStatus.execute(testMovieDetail.id));
        },
      );
    });
  });
}
