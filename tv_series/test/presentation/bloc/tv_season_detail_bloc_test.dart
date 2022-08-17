import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_season_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvSeasonDetail,
])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;
  late TvSeasonDetailBloc tvSeasonDetailBloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    tvSeasonDetailBloc = TvSeasonDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvSeasonDetail: mockGetTvSeasonDetail,
    );
  });

  test('initial state should be loading', () {
    expect(tvSeasonDetailBloc.state, TvSeasonDetailLoading());
  });

  group('Tv Season Detail', () {
    const tTvId = 1;
    const tSeasonNumber = 1;

    blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
      'should emit [Loading, HasData] when data gotten is successfully',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber))
            .thenAnswer((_) async => Right(testSeasonDetail));

        return tvSeasonDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeasonDetail(tTvId, tSeasonNumber)),
      expect: () => [
        TvSeasonDetailLoading(),
        TvSeasonDetailHasData(testTvDetail, testSeasonDetail),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tTvId));
        verify(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber));
      },
    );

    blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
      'should emit [Loading, Error] when failed to get tv detail',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeasonDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeasonDetail(tTvId, tSeasonNumber)),
      expect: () => [
        TvSeasonDetailLoading(),
        const TvSeasonDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tTvId));
        verify(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber));
      },
    );

    blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
      'should emit [Loading, Error] when failed to get season detail',
      build: () {
        when(mockGetTvDetail.execute(tTvId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeasonDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeasonDetail(tTvId, tSeasonNumber)),
      expect: () => [
        TvSeasonDetailLoading(),
        const TvSeasonDetailError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tTvId));
        verify(mockGetTvSeasonDetail.execute(tTvId, tSeasonNumber));
      },
    );
  });
}
