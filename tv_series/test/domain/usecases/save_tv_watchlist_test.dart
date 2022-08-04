import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvWatchlist useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = SaveTvWatchlist(mockTvRepository);
  });

  test('should save watchlist tv series from the repository', () async {
    // arrange
    when(mockTvRepository.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));

    // act
    final result = await useCase.execute(testTvDetail);

    // assert
    verify(mockTvRepository.saveWatchlist(testTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
