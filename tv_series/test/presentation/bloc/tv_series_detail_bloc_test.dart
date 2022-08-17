import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendation,
])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendation mockGetTvRecommendation;
  late TvSeriesDetailBloc tvSeriesDetailBloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendation = MockGetTvRecommendation();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendation: mockGetTvRecommendation,
    );
  });

  test('initial state should be loading', () {
    expect(tvSeriesDetailBloc.state, TvSeriesDetailLoading());
  });

  group('Tv Series Detail', () {
    final tTv = Tv(
      backdropPath: 'backdropPath',
      firstAirDate: DateTime.tryParse('firstAirDate'),
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
    const tId = 1;

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, HasData] when data gotten is successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendation.execute(tId))
            .thenAnswer((_) async => Right(tTvSeries));

        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesDetailHasData(tv: testTvDetail, recommendations: tTvSeries),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendation.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, Error] when data gotten is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendation.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        const TvSeriesDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendation.execute(tId));
      },
    );
  });
}
