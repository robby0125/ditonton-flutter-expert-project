import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeries useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetWatchlistTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    final result = await useCase.execute();

    // assert
    verify(mockTvRepository.getWatchlistTvSeries());
    expect(result, Right(tTvSeries));
  });
}
