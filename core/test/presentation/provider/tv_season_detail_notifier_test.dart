import 'package:core/domain/usecases/get_tv_season_detail.dart';
import 'package:core/presentation/provider/tv_season_detail_notifier.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';
import 'tv_season_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeasonDetail,
])
void main() {
  late TvSeasonDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    provider = TvSeasonDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvSeasonDetail: mockGetTvSeasonDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;
  const tSeasonNumber = 1;

  void _arrangeUseCase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));
  }

  group('Get Tv Detail', () {
    test('should change state to Loading when use case is called', () async {
      // arrange
      _arrangeUseCase();

      // act
      provider.fetchTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(provider.requestState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should update tv detail when data gotten successful', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvSeasonDetail(tId, tSeasonNumber);

      // assert
      verify(mockGetTvDetail.execute(tId));
      expect(provider.tvDetail, testTvDetail);
    });

    test('should update message when get data is failed', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(provider.requestState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Tv Season Detail', () {
    test('should update season detail when data gotten is successful',
        () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(provider.requestState, RequestState.Loaded);
      expect(provider.tvSeasonDetail, testSeasonDetail);
      expect(listenerCallCount, 2);
    });

    test('should update message when get data is failed', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchTvSeasonDetail(tId, tSeasonNumber);

      // assert
      expect(provider.requestState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Expand Episode Panel', () {
    test('should update expanded panel index when function is called',
        () async {
      // act
      provider.expandEpisodePanel(1);

      // assert
      expect(provider.curEpisodeExpanded, 1);
      expect(listenerCallCount, 1);
    });
  });
}
