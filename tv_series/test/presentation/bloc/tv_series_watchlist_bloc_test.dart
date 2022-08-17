import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  SaveTvWatchlist,
  RemoveTvWatchlist,
  GetTvWatchlistStatus,
])
void main() {
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;
  late TvSeriesWatchlistBloc tvSeriesWatchlistBloc;

  setUp(() {
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    tvSeriesWatchlistBloc = TvSeriesWatchlistBloc(
      saveTvWatchlist: mockSaveTvWatchlist,
      removeTvWatchlist: mockRemoveTvWatchlist,
      getTvWatchlistStatus: mockGetTvWatchlistStatus,
    );
  });

  test('initial state should be empty message and not added to watchlist', () {
    expect(tvSeriesWatchlistBloc.state, const TvSeriesWatchlistState());
    expect(tvSeriesWatchlistBloc.state.message, '');
    expect(tvSeriesWatchlistBloc.state.isAddedToWatchlist, false);
  });

  group('Watchlist Tv Series', () {
    group('Add Watchlist', () {
      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        'should emit TvSeriesWatchlistState with success message when add watchlist is successfully',
        build: () {
          when(mockSaveTvWatchlist.execute(testTvDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => true);
          return tvSeriesWatchlistBloc;
        },
        act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
        expect: () => [
          const TvSeriesWatchlistState(
            message: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ],
        verify: (bloc) {
          verify(mockSaveTvWatchlist.execute(testTvDetail));
          verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        },
      );

      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        'should emit TvSeriesWatchlistState with error message when add watchlist is successfully',
        build: () {
          when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer(
              (_) async => Left(DatabaseFailure('Database Failure')));
          when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return tvSeriesWatchlistBloc;
        },
        act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
        expect: () => [
          const TvSeriesWatchlistState(
            message: 'Database Failure',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockSaveTvWatchlist.execute(testTvDetail));
          verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        },
      );
    });

    group('Remove Watchlist', () {
      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        'should emit TvSeriesWatchlistState with success message when remove watchlist is successfully',
        build: () {
          when(mockRemoveTvWatchlist.execute(testTvDetail))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return tvSeriesWatchlistBloc;
        },
        act: (bloc) => bloc.add(RemoveWatchlist(testTvDetail)),
        expect: () => [
          const TvSeriesWatchlistState(
            message: 'Removed from Watchlist',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveTvWatchlist.execute(testTvDetail));
          verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        },
      );

      blocTest<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        'should emit TvSeriesWatchlistState with error message when remove watchlist is successfully',
        build: () {
          when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer(
              (_) async => Left(DatabaseFailure('Database Failure')));
          when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return tvSeriesWatchlistBloc;
        },
        act: (bloc) => bloc.add(RemoveWatchlist(testTvDetail)),
        expect: () => [
          const TvSeriesWatchlistState(
            message: 'Database Failure',
            isAddedToWatchlist: false,
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveTvWatchlist.execute(testTvDetail));
          verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        },
      );
    });
  });
}
