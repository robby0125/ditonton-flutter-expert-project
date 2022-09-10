import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(
      getWatchlistTvSeries: mockGetWatchlistTvSeries,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
  });

  group('Watchlist TV Series', () {
    final tWatchlistTvSeries = Tv.watchList(
      id: 1,
      overview: 'overview',
      posterPath: 'posterPath',
      name: 'name',
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, Empty] when tv series watchlist is empty',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Right([]));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesEmpty(),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, HasData] when tv series watchlist is not empty',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([tWatchlistTvSeries]));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesHasData([tWatchlistTvSeries]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [Loading, Error] when get tv series watchlist is failed',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTvSeries.execute());
      },
    );
  });
}
