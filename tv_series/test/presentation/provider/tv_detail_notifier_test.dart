import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendation,
  GetTvWatchlistStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendation mockGetTvRecommendation;
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendation = MockGetTvRecommendation();
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendation: mockGetTvRecommendation,
      getTvWatchlistStatus: mockGetTvWatchlistStatus,
      saveTvWatchlist: mockSaveTvWatchlist,
      removeTvWatchlist: mockRemoveTvWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;
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

  void _arrangeUseCase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendation.execute(tId))
        .thenAnswer((_) async => Right(tTvSeries));
  }

  group('Get Tv Detail', () {
    test('should get tv detail from use case', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvDetail(tId);

      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendation.execute(tId));
    });

    test('should change state to Loading when use case is called', () {
      // arrange
      _arrangeUseCase();

      // act
      provider.fetchTvDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change state to Error when get tv detail data is failed',
        () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendation.execute(tId))
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      await provider.fetchTvDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });

    test('should change tv when data is gotten successful', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvDetail(tId);

      // assert
      expect(provider.tv, testTvDetail);
      expect(provider.tvState, RequestState.Loaded);
      expect(listenerCallCount, 2);
    });

    test('should change tv recommendation when data is gotten successful',
        () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvDetail(tId);

      // assert
      verify(mockGetTvRecommendation.execute(tId));
      expect(provider.tvRecommendation, tTvSeries);
    });
  });

  group('Get Tv Recommendations', () {
    test('should get data from the use case', () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvDetail(tId);

      // assert
      verify(mockGetTvRecommendation.execute(tId));
      expect(provider.tvRecommendation, tTvSeries);
    });

    test('should change recommendation state when data is gotten successful',
        () async {
      // arrange
      _arrangeUseCase();

      // act
      await provider.fetchTvDetail(tId);

      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendation, tTvSeries);
    });

    test(
        'should change recommendation state and error message when get data is failed',
        () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendation.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchTvDetail(tId);

      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetTvWatchlistStatus.execute(tId)).thenAnswer((_) async => true);

      // act
      await provider.loadWatchlistStatus(tId);

      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Success'));
      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);

      // act
      await provider.addWatchlist(testTvDetail);

      // assert
      verify(mockSaveTvWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.removeFromWatchlist(testTvDetail);

      // assert
      verify(mockRemoveTvWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Success'));
      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);

      // act
      await provider.addWatchlist(testTvDetail);

      // assert
      verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Success');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.addWatchlist(testTvDetail);

      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(provider.isAddedToWatchlist, false);
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when removing watchlist failed',
        () async {
      // arrange
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      // act
      await provider.removeFromWatchlist(testTvDetail);

      // assert
      expect(provider.watchlistMessage, 'Failed');
    });
  });
}
