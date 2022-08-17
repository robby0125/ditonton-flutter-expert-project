import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetOnAirTvSeries])
void main() {
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;
  late NowPlayingTvSeriesBloc nowPlayingTvSeriesBloc;

  setUp(() {
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    nowPlayingTvSeriesBloc = NowPlayingTvSeriesBloc(
      getOnAirTvSeries: mockGetOnAirTvSeries,
    );
  });

  test('initial state should be loading', () {
    expect(nowPlayingTvSeriesBloc.state, NowPlayingTvSeriesLoading());
  });

  group('Now Playing Tv Series', () {
    final tTv = Tv(
      backdropPath: '/path.jpg',
      firstAirDate: DateTime.tryParse('2001-01-01'),
      genreIds: const [1, 2, 3],
      id: 1,
      name: 'name',
      originCountry: const ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: '/path.jpg',
      voteAverage: 1,
      voteCount: 1,
    );
    final tTvSeries = [tTv];

    blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
      'should emit [Loading, HasData] when data gotten successfully',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeries));

        return nowPlayingTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingTvSeries()),
      expect: () => [
        NowPlayingTvSeriesLoading(),
        NowPlayingTvSeriesHasData(tTvSeries),
      ],
      verify: (bloc) {
        verify(mockGetOnAirTvSeries.execute());
      },
    );

    blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetOnAirTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return nowPlayingTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlayingTvSeries()),
      expect: () => [
        NowPlayingTvSeriesLoading(),
        const NowPlayingTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetOnAirTvSeries.execute());
      },
    );
  });
}
