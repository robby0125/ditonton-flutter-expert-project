import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

void main() {
  late PopularTvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late int listenerCallCount;

  setUp(() async {
    listenerCallCount = 0;
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    provider = PopularTvSeriesNotifier(
      getPopularTvSeries: mockGetPopularTvSeries,
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

  test('should change state to Loading when use case is called', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    provider.fetchPopularTvSeries();

    // assert
    expect(provider.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should update tv series when data gotten is successful', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    await provider.fetchPopularTvSeries();

    // assert
    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, tTvSeries);
    expect(listenerCallCount, 2);
  });

  test('should update message when data gotten is failed', () async {
    // arrange
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    // act
    await provider.fetchPopularTvSeries();

    // assert
    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
