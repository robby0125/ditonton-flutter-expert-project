import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesBloc popularTvSeriesBloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(
      getPopularTvSeries: mockGetPopularTvSeries,
    );
  });

  test('initial state should be loading', () {
    expect(popularTvSeriesBloc.state, PopularTvSeriesLoading());
  });

  group('Popular Tv Series', () {
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

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emit [Loading, HasData] when data gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeries));

        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesHasData(tTvSeries),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        const PopularTvSeriesError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );
  });
}
