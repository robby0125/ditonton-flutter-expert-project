import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvWatchlist useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = RemoveTvWatchlist(mockTvRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));

    // act
    final result = await useCase.execute(testTvDetail);

    // assert
    verify(mockTvRepository.removeWatchlist(testTvDetail));
    expect(result, const Right('Removed from Watchlist'));
  });
}
