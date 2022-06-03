import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnAirTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries,
])
void main() {
  late TvListNotifier provider;
  late MockGetOnAirTvSeries mockGetOnAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAirTvSeries = MockGetOnAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TvListNotifier(
      getOnAirTvSeries: mockGetOnAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
    backdropPath: '/path.jpg',
    firstAirDate: DateTime.tryParse('2001-01-01'),
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: '/path.jpg',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeries = [tTv];

  group('Get On Air Tv Series', () {
    test('should change state to Loading when use case is called', () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      provider.fetchOnAirTvSeries();

      // assert
      verify(mockGetOnAirTvSeries.execute());
      expect(provider.onAirState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should update on air tv series when data gotten is successful',
        () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      await provider.fetchOnAirTvSeries();

      // assert
      expect(provider.onAirState, RequestState.Loaded);
      expect(provider.onAirTvSeries, tTvSeries);
      expect(listenerCallCount, 2);
    });

    test('should update message when data gotten is failed', () async {
      // arrange
      when(mockGetOnAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchOnAirTvSeries();

      // assert
      expect(provider.onAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Popular Tv Series', () {
    test('should change state to Loading when use case is called', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      provider.fetchPopularTvSeries();

      // assert
      verify(mockGetPopularTvSeries.execute());
      expect(provider.popularState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should update popular tv series when data gotten is successful',
        () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      await provider.fetchPopularTvSeries();

      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popularTvSeries, tTvSeries);
      expect(listenerCallCount, 2);
    });

    test('should update message when data gotten is failed', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchPopularTvSeries();

      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Top Rated Tv Series', () {
    test('should change state to Loading when use case is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeries));

      // act
      provider.fetchTopRatedTvSeries();

      // assert
      verify(mockGetTopRatedTvSeries.execute());
      expect(provider.topRatedState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should update popular tv series when data gotten is successful',
            () async {
          // arrange
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeries));

          // act
          await provider.fetchTopRatedTvSeries();

          // assert
          expect(provider.topRatedState, RequestState.Loaded);
          expect(provider.topRatedTvSeries, tTvSeries);
          expect(listenerCallCount, 2);
        });

    test('should update message when data gotten is failed', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      // act
      await provider.fetchTopRatedTvSeries();

      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
