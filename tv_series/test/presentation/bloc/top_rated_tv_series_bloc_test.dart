import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  test('initial state should be loading', () {
    expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesLoading());
  });

  group('Top Rated Tv Series', () {
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

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emit [Loading, HasData] when data gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeries));

        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesHasData(tTvSeries),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        const TopRatedTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );
  });
}
