import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'tv_list_notifier_test.mocks.dart';

void main() {
  late TopRatedTvSeriesNotifier provider;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TopRatedTvSeriesNotifier(
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

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

  test('should change state to Loading when use case is called', () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    provider.fetchTopRatedTvSeries();

    // assert
    expect(provider.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should update tv series when data gotten is successful', () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    await provider.fetchTopRatedTvSeries();

    // assert
    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, tTvSeries);
    expect(listenerCallCount, 2);
  });

  test('should update message when data gotten is failed', () async {
    // arrange
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    // act
    await provider.fetchTopRatedTvSeries();

    // assert
    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
